class UploadJobsController < BaseController

  before_action :require_user_acc
  before_action :load_election

  # deletes jobs
  def destroy
    UploadJob.find(params[:id]).destroy
    redirect_to @election
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

end
