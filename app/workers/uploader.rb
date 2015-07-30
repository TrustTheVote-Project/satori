class Uploader

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
  end

  # Log parsing handler
  class VTLParseHandler
    attr_reader :log

    def initialize(election, filename, uploader_id)
      @election = election
      @filename = filename
      @uploader_id = uploader_id
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

    def parsed_record(record)
      rec = @log.records.build
      rec.set_attributes_from_vtl(record)
      if rec.valid?
        rec.save
      else
        # DEBUG skip missing action nodes
        return unless rec.errors[:action].blank?
        raise "Failed to save record: #{rec.errors.full_messages.join(', ')}"
      end
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
    attr_reader :file

    def initialize(election, filename, uploader_id)
      @election = election
      @filename = filename
      @uploader_id = uploader_id
    end

    def parsed_header(header)
      @file = @election.demog_files.build
      @file.filename    = @filename || header.filename
      # @log.origin      = header.origin
      # @log.origin_uniq = header.origin_uniq
      # @log.create_date = header.create_date
      # @log.hash_alg    = header.hash_alg

      @file.uploader_id = @uploader_id
      @file.uploaded_at = Time.now.utc

      unless @file.save
        raise "Failed to save file: #{@file.errors.full_messages}"
      end
    end

    def parsed_record(record)
      rec = @file.records.build
      rec.set_attributes_from_demog(record)
      rec.election_id = @file.election_id
      if rec.valid?
        rec.save
      else
        raise "Failed to save record: #{rec.errors.full_messages.join(', ')}"
      end
    end

    def error(invalid_record)
      raise "Validation error: #{invalid_record.errors.join(', ')} - #{invalid_record.inspect}"
    end

    def xml_error(error)
      raise "XML error: #{error}"
    end
  end

end
