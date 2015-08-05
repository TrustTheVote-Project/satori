class Reports::VotersRace < ActiveRecord::Base
  self.table_name = "voters_race"

  def readonly?
    true
  end
end
