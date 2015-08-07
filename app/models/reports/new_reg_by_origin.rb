class Reports::NewRegByOrigin < ActiveRecord::Base
  self.table_name = "new_reg_by_origin"

  def readonly?
    true
  end
end
