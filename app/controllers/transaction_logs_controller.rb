class TransactionLogsController < BaseController

  before_action :require_user_acc
  before_action :load_election

  # lists transaction logs
  def index
    @logs    = @election.transaction_logs
    @uploads = @election.upload_jobs.vtl.active
    @errors  = @election.upload_jobs.vtl.errors
  end

  # parses the upload and creates log and records
  def create
    file = params[:upload][:file]

    job = @election.upload_jobs.create(url: file.path, kind: UploadJob::VTL, state: UploadJob::PENDING)

    Uploader.perform_async(job.id)

    redirect_to @election, notice: "Log uploaded"
  end

  # removes the log
  def destroy
    @election.transaction_logs.find(params[:id]).destroy
    redirect_to @election, notice: "Log deleted"
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

end
