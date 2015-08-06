class Reports::CancellationReasonsByLocality < ActiveRecord::Base
  self.table_name = "cancellation_reasons_by_locality"

  def readonly?
    true
  end
end
