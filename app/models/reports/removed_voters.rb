class Reports::RemovedVoters < ActiveRecord::Base
  self.table_name = "removed_voters"

  def readonly?
    true
  end
end
