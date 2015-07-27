class Reports::CountsByLocality < ActiveRecord::Base
  self.table_name = "counts_by_locality"

  def readonly?
    true
  end
end
