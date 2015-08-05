class CreateVoterDemographicsByLocalityView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW voter_demographics_by_locality AS
        SELECT election_id, jurisdiction,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE reg_status = 'Active') AS active,
          COUNT(*) FILTER (WHERE reg_status = 'Inactive') AS inactive,
          COUNT(*) FILTER (WHERE reg_status = 'Cancelled') AS cancelled,
          COUNT(*) FILTER (WHERE gender = 'Male') AS male,
          COUNT(*) FILTER (WHERE gender = 'Female') AS female,
          COUNT(*) FILTER (WHERE gender NOT IN ('Male', 'Female')) AS gender_unknown,
          COUNT(*) FILTER (WHERE overseas = 't') AS overseas,
          COUNT(*) FILTER (WHERE military = 't') AS military,
          COUNT(*) FILTER (WHERE protected = 't') AS protected,
          COUNT(*) FILTER (WHERE disabled = 't') AS disabled,
          COUNT(*) FILTER (WHERE absentee_ongoing = 't') AS absentee_ongoing,
          COUNT(*) FILTER (WHERE absentee_in_this_election = 't') AS absentee_in_this_election
        FROM demog_records
        GROUP BY election_id, jurisdiction
        ORDER BY jurisdiction;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS voter_demographics_by_locality;
    }
  end
end
