class Uploader

  MAX_BATCH_RECORDS = 1000
  MAX_RECORDS       = 10_000_000

  include Sidekiq::Worker

  def perform(job_id, uploader_id)
    job = UploadJob.find(job_id)
    send "upload_#{job.kind}", job, uploader_id
  end

  private

  def upload_vtl(job, uploader_id)
    return if job.election.nil?

    handler = VTLParseHandler.new(job.election, job.filename, uploader_id)

    TransactionLog.transaction do
      job.start!

      if job.url =~ /^http/
        VTL.parse_uri(job.url, handler)
      else
        VTL.parse_file(job.url, handler)
      end

      Reports.refresh
      job.finish!
    end

    log = handler.log
    log.reload
    log.recalculate_stats!
  rescue => e
    job.abort!(e.message)
    raise e
  ensure
    cleanup(job)
  end

  def upload_demog(job, uploader_id)
    return if job.election.nil?

    handler = DemogParseHandler.new(job.election, job.filename, uploader_id)

    DemogFile.transaction do
      job.start!
      if job.url =~ /^http/
        Demog.parse_uri(job.url, handler)
      else
        Demog.parse_file(job.url, handler)
      end

      Reports.refresh
      job.finish!
    end

    file = handler.file
    file.reload
    file.recalculate_stats!
  rescue => e
    job.abort!(e.message)
    raise e
  ensure
    cleanup(job)
  end

  def cleanup(job)
    if job.url =~ /^http/
      cleanup_url(job.url)
    else
      FileUtils.rm(job.url)
    end
  end

  def cleanup_url(url)
    key = get_amazon_key(url)
    return if key.nil?

    aws    = AppConfig['aws']
    creds  = Aws::Credentials.new(aws['access_key_id'], aws['secret_access_key'])
    client = Aws::S3::Client.new(region: aws['region'], credentials: creds)
    client.delete_object(key: key, bucket: aws['s3_bucket'])
  end

  def get_amazon_key(url)
    if m = url.scan(/\.amazonaws\.com\/#{AppConfig['aws']['s3_bucket']}\/(.+)$/) and m.flatten.size > 0
      return m.flatten.first
    else
      return nil
    end
  end

  # Log parsing handler
  class VTLParseHandler

    COLS = [ :account_id, :election_id, :log_id, :voter_id, :recorded_at, :action, :jurisdiction, :form, :form_note, :leo, :notes, :comment ]

    attr_reader :log

    def initialize(election, filename, uploader_id)
      @election      = election
      @filename      = filename
      @uploader_id   = uploader_id

      @records       = []
      @batch_records = 0
      @max_records   = MAX_RECORDS
    end

    def parsed_header(header)
      @log = @election.transaction_logs.build
      @log.filename    = @filename || header.filename
      @log.origin      = header.origin
      @log.origin_uniq = header.origin_uniq
      @log.create_date = header.create_date
      @log.hash_alg    = header.hash_alg

      @log.uploader_id = @uploader_id
      @log.uploaded_at = Time.now.utc

      unless @log.save
        raise "Failed to save log: #{@log.errors.full_messages}"
      end
    end

    def flush_batch
      TransactionRecord.import COLS, @records, validate: false
      @records.clear
      @batch_records = 0
    end

    def parsed_record(record)
      flush_batch if @batch_records == MAX_BATCH_RECORDS

      if @max_records == 0
        flush_batch if @batch_records > 0
        raise "Max records"
      end

      @batch_records += 1
      @max_records -= 1

      rec = [ @election.account_id, @election.id, @log.id, record.voter_id, record.date, record.action, record.jurisdiction, record.form,
              record.form_note, record.leo, record.notes.try(:first), record.comment ]
      @records << rec
    end

    def error(invalid_record)
      raise "Validation error: #{invalid_record.errors.join(', ')} - #{invalid_record.inspect}"
    end

    def xml_error(error)
      raise "XML error: #{error}"
    end
  end

  # Log parsing handler
  class DemogParseHandler
    COLS = [ :account_id, :election_id, :demog_file_id, :voter_id, :jurisdiction, :reg_date, :year_of_birth, :reg_status, :gender, :race,
             :political_party_name, :overseas, :military, :protected, :disabled, :absentee_ongoing,
             :absentee_in_this_election, :precinct_split_id, :zip_code ]

    attr_reader :file

    def initialize(election, filename, uploader_id)
      @election      = election
      @filename      = filename
      @uploader_id   = uploader_id

      @records       = []
      @batch_records = 0
      @max_records   = MAX_RECORDS
    end

    def parsed_header(header)
      @file = @election.demog_files.build
      @file.filename    = @filename || header.filename
      @file.origin      = header.origin
      @file.origin_uniq = header.origin_uniq
      @file.create_date = header.create_date
      @file.hash_alg    = header.hash_alg

      @file.uploader_id = @uploader_id
      @file.uploaded_at = Time.now.utc

      unless @file.save
        raise "Failed to save file: #{@file.errors.full_messages}"
      end
    end

    def flush_batch
      DemogRecord.import COLS, @records, validate: false
      @records.clear
      @batch_records = 0
    end

    def parsed_record(record)
      flush_batch if @batch_records == MAX_BATCH_RECORDS

      if @max_records == 0
        flush_batch if @batch_records > 0
        raise "Max records"
      end

      @batch_records += 1
      @max_records -= 1

      rec = [
        @election.account_id,
        @election.id,
        @file.id,
        record.voter_id,
        record.jurisdiction,
        record.reg_date,
        record.year_of_birth,
        record.reg_status,
        record.gender,
        record.race,
        record.political_party_name,
        record.overseas,
        record.military,
        record.protected,
        record.disabled,
        record.absentee_ongoing,
        record.absentee_in_this_election,
        record.precinct_split_id,
        record.zip_code ]

      @records << rec
    end

    def error(invalid_record)
      raise "Validation error: #{invalid_record.errors.join(', ')} - #{invalid_record.inspect}"
    end

    def xml_error(error)
      raise "XML error: #{error}"
    end
  end

end
