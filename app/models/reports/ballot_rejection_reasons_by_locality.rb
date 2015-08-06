class Reports::BallotRejectionReasonsByLocality < ActiveRecord::Base
  self.table_name = "ballot_rejection_reasons_by_locality"

  def readonly?
    true
  end
end
