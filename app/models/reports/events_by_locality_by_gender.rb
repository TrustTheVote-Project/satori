class Reports::EventsByLocalityByGender < ActiveRecord::Base
  self.table_name = "events_by_locality_by_gender"

  def readonly?
    true
  end
end
