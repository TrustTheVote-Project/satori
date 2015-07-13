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
    @election = current_account.elections.find(params[:id])
  end

  # creates election
  def create
    @election = current_account.elections.build(elec_params)
    if @election.save
      redirect_to @election, notice: "Election created"
    else
      render :new
    end
  end

  def destroy
    current_account.elections.find(params[:id]).destroy
    redirect_to :dashboard, notice: "Election deleted"
  end

  private

  def elec_params
    params[:election].permit(:name, :held_on, :voter_start_on, :voter_end_on, :reg_deadline_on, :ab_req_deadline_on, :ab_rec_deadline_on, :ffd_deadline_on)
  end

end
