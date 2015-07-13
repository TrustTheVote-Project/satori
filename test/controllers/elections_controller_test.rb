require 'test_helper'

class ElectionsControllerTest < ActionController::TestCase

  include Sorcery::TestHelpers::Rails::Controller

  setup { login_user users(:user) }

  test 'new form' do
    get :new
    assert_template :new
  end

  test 'showing elections' do
    get :show, id: elections(:one).id
    assert_template :show
    assert_equal elections(:one), assigns(:election)
  end

  test 'not showing someone elses elections' do
    get :show, id: elections(:home).id
    assert_redirected_to :dashboard
  end

  test 'create succesfully' do
    post :create, election: { name: "Election" }
    e = Election.last
    assert_equal users(:user).account, e.account
    assert_redirected_to e
  end

  test 'deleting elections' do
    delete :destroy, id: elections(:one).id
    assert_redirected_to :dashboard
    assert_equal 'Election deleted', flash.notice
  end

  test 'not deleting foreign elections' do
    delete :destroy, id: elections(:home).id
    assert_redirected_to :dashboard
    assert_equal 'Election not found', flash.alert
  end

end
