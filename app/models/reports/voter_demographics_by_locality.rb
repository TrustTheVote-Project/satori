class Reports::VoterDemographicsByLocality < ActiveRecord::Base
  self.table_name = "voter_demographics_by_locality"

  def readonly?
    true
  end
end
