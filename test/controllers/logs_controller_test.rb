require 'test_helper'

class LogsControllerTest < ActionController::TestCase

  include Sorcery::TestHelpers::Rails::Controller

  setup { login_user users(:user) }

  test 'new' do
    get :new, election_id: election.id
    assert_template :new
  end

  test 'failed VTL parsing on create' do
    VTL.expects(:parse).raises(VTL::ValidationError, "abc")
    post :create, election_id: election.id, upload: { file: 'xml' }
    assert_template :new
    assert_equal "Failed to parse VTL: abc", flash.now[:alert]
  end

  test 'successful VTL parsing on create' do
    VTL.expects(:parse).returns(log)
    post :create, election_id: election.id, upload: { file: fixture_file_upload('/files/empty.xml', 'application/xml') }
    assert_redirected_to election
    assert_equal "File uploaded", flash.notice

    l = election.logs.last
    assert_equal 'empty.xml', l.filename
    assert_equal 'VA Data', l.origin
    assert_equal 'OU', l.origin_uniq
    assert_equal 'SHA1', l.hash_alg
    assert_equal log.create_date.to_s, l.create_date.to_s

    r = l.records.first
    assert_equal 'VID', r.voter_id
    assert_equal log.records.first.date.to_s, r.recorded_at.to_s
    assert_equal 'approve', r.action
    assert_equal 'VoterRecordUpdate', r.form
    assert_equal 'PRINCE C', r.jurisdiction
    assert_equal 'handMarked', r.form_note
    assert_equal 'LEO', r.leo
    assert_equal 'rejectLate', r.notes
    assert_equal 'comment', r.comment
  end

  def election
    @election ||= elections(:one)
  end

  def log
    log = VTL::VoterTransactionLog.new
    log.origin       = 'VA Data'
    log.origin_uniq  = 'OU'
    log.hash_alg     = 'SHA1'
    log.create_date  = 1.month.ago

    rec = VTL::VoterTransactionRecord.new
    rec.voter_id     = 'VID'
    rec.date         = 1.week.ago
    rec.action       = 'approve'
    rec.form         = 'VoterRecordUpdate'
    rec.jurisdiction = 'PRINCE C'
    rec.form_note    = 'handMarked'
    rec.leo          = 'LEO'
    rec.notes        = 'rejectLate'
    rec.comment      = 'comment'

    log.records << rec
    log
  end

end
