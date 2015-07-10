require 'test_helper'

class ElectionsControllerTest < ActionController::TestCase

  include Sorcery::TestHelpers::Rails::Controller

  setup { login_user users(:user) }

  test 'new form' do
    get :new
    assert_template :new
  end

  test 'create succesfully' do
    post :create, election: { name: "Election" }
    e = Election.last
    assert_redirected_to e
  end

end
