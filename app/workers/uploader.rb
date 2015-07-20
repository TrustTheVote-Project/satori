class Uploader

  include Sidekiq::Worker

  def perform(job_id)
    job = UploadJob.find(job_id)
    send "upload_#{job.kind}", job
  end

  private

  def upload_vtl(job)
    return if job.election.nil?

    job.start!
    TransactionLog.transaction do
      handler = VTLParseHandler.new(job.election)
      if job.url =~ /^http/
        VTL.parse_uri(job.url, handler)
      else
        VTL.parse_file(job.url, handler)
      end
      job.finish!
    end
  rescue => e
    job.abort!(e.message)
  end

  def upload_demog(job)
  end

  # Log parsing handler
  class VTLParseHandler
    def initialize(election)
      @election = election
    end

    def parsed_header(header)
      @log = @election.transaction_logs.build
      @log.filename    = header.filename
      @log.origin      = header.origin
      @log.origin_uniq = header.origin_uniq
      @log.create_date = header.create_date
      @log.hash_alg    = header.hash_alg
      unless @log.save
        raise "Failed to save log: #{@log.errors.full_messages}"
      end
    end

    def parsed_record(record)
      rec = @log.records.build
      rec.set_attributes_from_vtl(record)
      unless rec.save
        raise "Failed to save record: #{rec.errors.full_messages}"
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
