class Reports::TotalRegByOrigin < ActiveRecord::Base
  self.table_name = "total_reg_by_origin"

  def readonly?
    true
  end
end
