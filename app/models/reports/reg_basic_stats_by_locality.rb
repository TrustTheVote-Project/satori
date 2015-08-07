class Reports::RegBasicStatsByLocality < ActiveRecord::Base
  self.table_name = "reg_basic_stats_by_locality"

  def readonly?
    true
  end
end
