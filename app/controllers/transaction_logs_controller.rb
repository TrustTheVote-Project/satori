class TransactionLogsController < BaseController

  before_action :require_user_acc
  before_action :load_election

  # lists transaction logs
  def index
    @logs    = @election.transaction_logs
    @uploads = @election.upload_jobs.vtl.active
    @errors  = @election.upload_jobs.vtl.errors
  end

  # new upload form
  def new
    @title      = "Upload New Voter Transaction Log"
    @submit_url = [ @election, :transaction_logs ]
    @urls       = S3Presigner.presign
    render 'shared/file_upload'
  end

  # parses the upload and creates log and records
  def create
    file = params[:resource_url]
    uri  = URI.parse(file)
    name = File.basename(uri.path)

    job = @election.upload_jobs.build(url: file, filename: name, kind: UploadJob::VTL, state: UploadJob::PENDING)

    if job.save
      Uploader.perform_async(job.id, current_user.id)
      redirect_to @election, notice: "Log uploaded and parsing scheduled"
    else
      render :new
    end
  end

  # removes the log
  def destroy
    if @election.transaction_logs.find(params[:id]).destroy
      Reports.refresh
    end

    redirect_to @election, notice: "Log deleted"
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

end
