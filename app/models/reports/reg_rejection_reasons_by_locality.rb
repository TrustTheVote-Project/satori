class Reports::RegRejectionReasonsByLocality < ActiveRecord::Base
  self.table_name = "reg_rejection_reasons_by_locality"

  def readonly?
    true
  end
end
