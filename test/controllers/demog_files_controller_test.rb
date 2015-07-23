require 'test_helper'

class DemogFilesControllerTest < ActionController::TestCase

  include Sorcery::TestHelpers::Rails::Controller

  setup { login_user users(:user) }

  test 'new' do
    get :new, election_id: election.id
    assert_template :new
  end

  test 'successful parsing on create' do
    UploadJob.delete_all
    Uploader.expects(:perform_async)
    post :create, election_id: election.id, upload: { file: fixture_file_upload('/files/empty.xml', 'application/xml') }
    assert_redirected_to election
    assert_equal "Demographics data uploaded and parsing scheduled", flash.notice

    job = UploadJob.last
    assert_equal election.id, job.election_id
    assert_equal 'empty.xml', job.filename
    assert_not_nil job.url
    assert_equal UploadJob::DEMOG, job.kind
    assert_equal UploadJob::PENDING, job.state
  end

  def election
    @election ||= elections(:one)
  end

end
