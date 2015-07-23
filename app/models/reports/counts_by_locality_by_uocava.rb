class Reports::CountsByLocalityByUocava < ActiveRecord::Base
  self.table_name = "counts_by_locality_by_uocava"
  def readonly?
    true
  end
end
