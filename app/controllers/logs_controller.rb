class LogsController < BaseController

  before_action :require_user_acc
  before_action :load_election

  # parses the upload and creates log and records
  def create
    file = params[:upload][:file]
    parsed_log = VTL.parse(file)

    Log.transaction do
      log = @election.logs.build(filename: file.original_filename)
      log.set_attributes_from_vtl(parsed_log)

      if log.save
        parsed_log.records.each do |pr|
          rec = log.records.build
          rec.set_attributes_from_vtl(pr)
          unless rec.save
            raise "Failed to save record: #{rec.errors.full_messages}"
          end
        end
      else
        raise "Failed to save log: #{log.errors.full_messages}"
      end
    end

    redirect_to @election, notice: "Log uploaded"
  rescue VTL::ValidationError => e
    flash.now.alert = "Failed to parse VTL: #{e.message}"
    render :new
  end

  # removes the log
  def destroy
    @election.logs.find(params[:id]).destroy
    redirect_to @election, notice: "Log deleted"
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

end
