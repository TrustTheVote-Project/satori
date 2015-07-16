class DemogFilesController < BaseController

  before_action :require_user_acc
  before_action :load_election

  # parses the upload and creates log and records
  def create
    xml_file = params[:upload][:file]

    DemogFile.transaction do
      file = @election.demog_files.build(filename: xml_file.original_filename)
      if file.save
        account_id = file.account_id
        election_id = file.election_id

        Demog.parse(xml_file.path) do |r|
          file.records.create!(r.merge(account_id: account_id, election_id: election_id).permit!)
        end
      else
        raise "Failed to save demographics file: #{file.errors.full_messages}"
      end
    end

    redirect_to @election, notice: "Demographics data uploaded"
  rescue Demog::ValidationError => e
    flash.now.alert = "Failed to parse demographics XML: #{e.message}"
    render :new
  end

  # removes the log
  def destroy
    @election.demog_files.find(params[:id]).destroy
    redirect_to @election, notice: "Log deleted"
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

end
