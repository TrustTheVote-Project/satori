class Reports::CountsByLocalityByDemog < ActiveRecord::Base
  self.table_name = "counts_by_locality_by_demog"

  def readonly?
    true
  end
end
