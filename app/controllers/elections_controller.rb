class ElectionsController < BaseController

  before_action :require_user_acc

  # new election form
  def new
    @election = Election.new
  end

  # creates election
  def create
    @election = Election.new(elec_params)
    if @election.save
      redirect_to [ @election, :logs ], notice: "Election created"
    else
      render :new
    end
  end

  private

  def elec_params
    params[:election].permit(:name, :held_on, :voter_start_on, :voter_end_on, :reg_deadline_on, :ab_req_deadline_on, :ab_rec_deadline_on, :ffd_deadline_on)
  end

end
