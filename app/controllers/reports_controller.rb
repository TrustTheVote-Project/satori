class ReportsController < BaseController

  before_action :require_user_acc
  before_action :load_election

  def events_by_county
    @report = EventsByCountyReport.new(@election.records.select("jurisdiction, action, form, count(*) as cnt").group("jurisdiction, action, form"))
  end

  private

  def load_election
    @election = current_account.elections.find(params[:election_id])
  end

end
