class CreateEventsByLocalityByGenderView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW events_by_locality_by_gender AS
        WITH records AS (
            SELECT t.election_id, t.jurisdiction, ACTION, form, gender
            FROM transaction_records t LEFT JOIN demog_records d ON t.voter_id = d.voter_id
            WHERE t.election_id = d.election_id
          ),
          voters AS (
            SELECT election_id, jurisdiction, gender
            FROM demog_records
          )

        -- total, overseas, local

        SELECT election_id, jurisdiction, 'Registered Voters' AS KEY,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE gender = 'Male') AS male,
          COUNT(*) FILTER (WHERE gender = 'Female') AS female
        FROM voters
        GROUP BY election_id, jurisdiction

        UNION ALL

        -- approve and reject

        SELECT election_id, jurisdiction, CONCAT(ACTION, ' - ' || form) AS KEY,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE gender = 'Male') AS male,
          COUNT(*) FILTER (WHERE gender = 'Female') AS female
        FROM records
        WHERE ACTION IN ('approve', 'reject') AND form IS NOT NULL
        GROUP BY election_id, jurisdiction, KEY

        UNION ALL

        -- cancelVoterRecord and voterPollCheckin

        SELECT election_id, jurisdiction, ACTION AS KEY,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE gender = 'Male') AS male,
          COUNT(*) FILTER (WHERE gender = 'Female') AS female
        FROM records
        WHERE ACTION IN ('cancelVoterRecord', 'voterPollCheckin')
        GROUP BY election_id, jurisdiction, KEY

        UNION ALL

        -- sentToVoter

        SELECT election_id, jurisdiction, ACTION AS KEY,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE gender = 'Male') AS male,
          COUNT(*) FILTER (WHERE gender = 'Female') AS female
        FROM records
        WHERE ACTION = 'sentToVoter' AND form IN ('VoterCard', 'AbsenteeBallot')
        GROUP BY election_id, jurisdiction, KEY

        UNION ALL

        -- receive and returnedUndelivered

        SELECT election_id, jurisdiction, ACTION AS KEY,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE gender = 'Male') AS male,
          COUNT(*) FILTER (WHERE gender = 'Female') AS female
        FROM records
        WHERE form = 'AbsenteeBallot' AND ACTION IN ('receive', 'returnedUndelivered')
        GROUP BY election_id, jurisdiction, KEY

        ORDER BY jurisdiction, KEY;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS events_by_locality_by_gender;
    }
  end
end
