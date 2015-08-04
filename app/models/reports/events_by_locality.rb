class Reports::EventsByLocality < ActiveRecord::Base
  self.table_name = "events_by_locality"

  def readonly?
    true
  end
end
