class CreateEventsByLocalityByUocavaView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW events_by_locality_by_uocava AS
        WITH records AS (
            SELECT t.election_id, t.jurisdiction, action, form, overseas = 't' OR military = 't' AS uocava
            FROM transaction_records t LEFT JOIN demog_records d ON t.voter_id = d.voter_id
            WHERE t.election_id = d.election_id
          ),
          voters AS (
            SELECT election_id, jurisdiction, voter_id, overseas = 't' OR military = 't' AS uocava
            FROM demog_records
          )

        -- total, overseas, local

        SELECT election_id, jurisdiction, 'Registered Voters' AS key,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE uocava = 't') AS uocava,
          COUNT(*) FILTER (WHERE uocava = 'f') AS local
        FROM voters
        GROUP BY election_id, jurisdiction

        UNION ALL

        -- approve and reject

        SELECT election_id, jurisdiction, CONCAT(action, ' - ' || form) AS key,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE uocava = 't') AS uocava,
          COUNT(*) FILTER (WHERE uocava = 'f') AS local
        FROM records
        WHERE action IN ('approve', 'reject') AND form IS NOT NULL
        GROUP BY election_id, jurisdiction, key

        UNION ALL

        -- cancelVoterRecord and voterPollCheckin

        SELECT election_id, jurisdiction, action AS key,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE uocava = 't') AS uocava,
          COUNT(*) FILTER (WHERE uocava = 'f') AS local
        FROM records
        WHERE action IN ('cancelVoterRecord', 'voterPollCheckin')
        GROUP BY election_id, jurisdiction, key

        UNION ALL

        -- sentToVoter

        SELECT election_id, jurisdiction, action AS key,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE uocava = 't') AS uocava,
          COUNT(*) FILTER (WHERE uocava = 'f') AS local
        FROM records
        WHERE action = 'sentToVoter' AND form IN ('VoterCard', 'AbsenteeBallot')
        GROUP BY election_id, jurisdiction, key

        UNION ALL

        -- receive and returnedUndelivered

        SELECT election_id, jurisdiction, action AS key,
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE uocava = 't') AS uocava,
          COUNT(*) FILTER (WHERE uocava = 'f') AS local
        FROM records
        WHERE form = 'AbsenteeBallot' AND action IN ('receive', 'returnedUndelivered')
        GROUP BY election_id, jurisdiction, key

        ORDER BY jurisdiction, key;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS events_by_locality_by_uocava;
    }
  end
end
