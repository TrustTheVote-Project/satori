class DemogFilesController < BaseController

  before_action :require_user_acc
  before_action :load_election

  # lists demog files
  def index
    @files   = @election.demog_files
    @uploads = @election.upload_jobs.demog.active
    @errors  = @election.upload_jobs.demog.errors
  end

  def new
    @title      = "Upload New Voter Demographics"
    @submit_url = [ @election, :demog_files ]
    @urls       = S3Presigner.presign
    render 'shared/file_upload'
  end

  # parses the upload and creates log and records
  def create
    file = params[:resource_url]
    uri  = URI.parse(file)
    name = File.basename(uri.path)

    job = @election.upload_jobs.build(url: file, filename: name, kind: UploadJob::DEMOG, state: UploadJob::PENDING)

    if job.save
      Uploader.perform_async(job.id, current_user.id)
      redirect_to @election, notice: "Demographics data uploaded and parsing scheduled"
    else
      render :new
    end
  end

  # removes the log
  def destroy
    if @election.demog_files.find(params[:id]).destroy
      Reports.refresh
    end

    redirect_to @election, notice: "Log deleted"
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

end
