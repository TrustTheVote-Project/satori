class Reports::EventsByCountyByDemog < ActiveRecord::Base
  self.table_name = "events_by_county_by_demog"

  def readonly?
    true
  end
end
