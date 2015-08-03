class Reports::CountsByCounty < ActiveRecord::Base
  self.table_name = "counts_by_county"

  def readonly?
    true
  end
end
