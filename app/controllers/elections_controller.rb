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
      format.json do
        @demog_files = @election.demog_files
        @vt_logs     = @election.transaction_logs
        @uploads     = @election.upload_jobs.active
        @errors      = @election.upload_jobs.errors
      end

      format.html do
        gon.data_url        = election_url(@election, format: 'json')
        gon.new_vtl_url     = new_election_transaction_log_url(@election)
        gon.new_demog_url   = new_election_demog_file_url(@election)
        gon.lock_data_url   = lock_data_election_url(@election)
        gon.unlock_data_url = unlock_data_election_url(@election)
        gon.election_name   = @election.name
        gon.complete_message = t('.complete_message')
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

  # locks data
  def lock_data
    @election = election
    @election.data_locked = true
    @election.save!

    show
    render :show
  end

  # unlocks data
  def unlock_data
    @election = election
    @election.data_locked = false
    @election.save!

    show
    render :show
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
