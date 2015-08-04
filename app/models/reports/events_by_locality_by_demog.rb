class Reports::EventsByLocalityByDemog < ActiveRecord::Base
  self.table_name = "events_by_locality_by_demog"

  def readonly?
    true
  end
end
