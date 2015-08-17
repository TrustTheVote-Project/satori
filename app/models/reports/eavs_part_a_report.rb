class Reports::EAVSPartAReport < ActiveRecord::Base
  self.table_name = "eavs_part_a_report"

  def readonly?
    true
  end
end
