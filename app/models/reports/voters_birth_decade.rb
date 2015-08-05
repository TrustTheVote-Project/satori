class Reports::VotersBirthDecade < ActiveRecord::Base
  self.table_name = "voters_birth_decade"

  def readonly?
    true
  end
end
