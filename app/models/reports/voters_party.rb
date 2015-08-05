class Reports::VotersParty < ActiveRecord::Base
  self.table_name = "voters_party"

  def readonly?
    true
  end
end
