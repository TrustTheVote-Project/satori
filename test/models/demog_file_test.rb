require 'test_helper'

class DemogFileTest < ActiveSupport::TestCase

  test "init of account" do
    e = elections(:one)
    f = DemogFile.new(election: e)
    f.valid?
    assert_equal e.account, f.account
  end

end
