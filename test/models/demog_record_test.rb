require 'test_helper'

class DemogRecordTest < ActiveSupport::TestCase

  test "init of election" do
    f = demog_files(:one)
    r = DemogRecord.new(file: f)
    r.valid?
    assert_equal f.election.id, r.election_id
    assert_equal f.account.id, r.account_id
  end

  test "field coercion" do
    fail "tbd"
  end

end
