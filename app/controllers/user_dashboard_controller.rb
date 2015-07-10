class UserDashboardController < BaseController

  before_action :require_user_acc

  # user dashboard
  def show
    @elections = Election.all
  end

end
