class Reports::CountsByLocalityByGender < ActiveRecord::Base
  self.table_name = "counts_by_locality_by_gender"

  def readonly?
    true
  end
end
