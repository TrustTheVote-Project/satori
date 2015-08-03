class Reports::CountsByCountyByDemog < ActiveRecord::Base
  self.table_name = "counts_by_county_by_demog"

  def readonly?
    true
  end
end
