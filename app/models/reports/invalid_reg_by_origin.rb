class Reports::InvalidRegByOrigin < ActiveRecord::Base
  self.table_name = "invalid_reg_by_origin"

  def readonly?
    true
  end
end
