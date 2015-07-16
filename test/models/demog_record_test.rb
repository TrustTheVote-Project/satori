require 'test_helper'

class DemogRecordTest < ActiveSupport::TestCase

  test "init of election" do
    f = demog_files(:one)
    r = DemogRecord.new(file: f)
    r.valid?
    assert_equal f.election, r.election
    assert_equal f.account, r.account
  end

  test "field coercion" do
    fail "tbd"
  end

end
