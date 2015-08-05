class ElectionsController < BaseController

  before_action :require_user_acc

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to :dashboard, alert: 'Election not found'
  end

  # new election form
  def new
    @election = Election.new
  end

  # election
  def show
    @election = election
    respond_to do |format|
      format.html do
        gon.data_url = election_url(@election)
      end

      format.json do
        @demog_files = @election.demog_files
        @vt_logs     = @election.transaction_logs
        @uploads     = @election.upload_jobs.active
        @errors      = @election.upload_jobs.errors
      end
    end
  end

  # creates election
  def create
    @election = Election.new(elec_params)
    @election.account = current_account
    @election.owner   = current_user
    if @election.save
      redirect_to @election, notice: "Election created"
    else
      render :new
    end
  end

  # election edit form
  def edit
    @election = election
  end

  # updates the election
  def update
    @election = election
    if @election.update_attributes(elec_params)
      redirect_to election, notice: "Election updated"
    else
      render :edit
    end
  end

  # deletes election
  def destroy
    election.destroy
    redirect_to :dashboard, notice: "Election deleted"
  end

  private

  def election
    Election.where(account: current_account).find(params[:id])
  end

  def elec_params
    params[:election].permit(:name, :held_on, :voter_start_on, :voter_end_on, :reg_deadline_on, :ab_req_deadline_on, :ab_rec_deadline_on, :ffd_deadline_on)
  end

end
