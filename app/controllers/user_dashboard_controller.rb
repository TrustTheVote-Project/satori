class UserDashboardController < BaseController

  before_action :require_user_acc

  # user dashboard
  def show
    @elections = Election.where(account: current_account).all
    gon.elections = @elections.map do |e|
      { id:             e.id,
        name:           e.name,
        url:            election_url(e),
        held_on:        e.held_on.try(:strftime, "%d %B %Y"),
        voter_start_on: e.voter_start_on.try(:strftime, "%d %B %Y"),
        voter_end_on:   e.voter_end_on.try(:strftime, "%d %B %Y"),
        locked:         e.data_locked,
        owner:          e.owner.try(:full_name) || 'Unknown' }
    end
  end

end
