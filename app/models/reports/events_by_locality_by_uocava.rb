class Reports::EventsByLocalityByUocava < ActiveRecord::Base
  self.table_name = "events_by_locality_by_uocava"

  def readonly?
    true
  end
end
