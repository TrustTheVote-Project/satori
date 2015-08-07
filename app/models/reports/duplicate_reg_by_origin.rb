class Reports::DuplicateRegByOrigin < ActiveRecord::Base
  self.table_name = "duplicate_reg_by_origin"

  def readonly?
    true
  end
end
