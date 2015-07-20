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
    return if job.election.nil?

    job.start!
    DemogFile.transaction do
      handler = DemogParseHandler.new(job.election)
      if job.url =~ /^http/
        Demog.parse_uri(job.url, handler)
      else
        Demog.parse_file(job.url, handler)
      end
      job.finish!
    end
  rescue => e
    job.abort!(e.message)

#       file = @election.demog_files.build(filename: xml_file.original_filename)
#       if file.save
#         account_id = file.account_id
#         election_id = file.election_id

#         Demog.parse(xml_file.path) do |r|
#           file.records.create!(r.merge(account_id: account_id, election_id: election_id).permit!)
#         end
#       else
#         raise "Failed to save demographics file: #{file.errors.full_messages}"
#       end
#     end

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

  # Log parsing handler
  class DemogParseHandler
    def initialize(election)
      @election = election
    end

    def parsed_header(header)
      @file = @election.demog_files.build
      @file.filename    = header.filename
      # @log.origin      = header.origin
      # @log.origin_uniq = header.origin_uniq
      # @log.create_date = header.create_date
      # @log.hash_alg    = header.hash_alg
      unless @file.save
        raise "Failed to save file: #{@file.errors.full_messages}"
      end
    end

    def parsed_record(record)
      rec = @file.records.build
      rec.set_attributes_from_demog(record)
      rec.election_id = @file.election_id
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
