class Reports::RegFormsReceivedByLocality < ActiveRecord::Base
  self.table_name = "reg_forms_received_by_locality"

  def readonly?
    true
  end
end
