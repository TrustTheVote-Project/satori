require 'test_helper'

class ReportsControllerTest < ActionController::TestCase

  include Sorcery::TestHelpers::Rails::Controller

  setup { login_user users(:user) }

  test 'events_by_county' do
    get :events_by_county, election_id: election.id
    assert_not_nil assigns(:report)
  end

  def election
    @election ||= elections(:one)
  end

end
