class Reports::EventsByCounty < ActiveRecord::Base
  self.table_name = "events_by_county"

  def readonly?
    true
  end
end
