class RecreateEventsByCountyByUocavaView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS events_by_county_by_demog;
      CREATE MATERIALIZED VIEW events_by_county_by_demog AS
        WITH records AS (
            SELECT t.election_id, t.jurisdiction, action, form, COALESCE(gender, 'No gender') AS gender, CASE WHEN overseas = 't' OR military = 't' THEN 'UOCAVA' ELSE 'Local' END AS overseas
            FROM transaction_records t LEFT JOIN demog_records d ON t.voter_id = d.voter_id
            WHERE t.election_id=d.election_id
          ),
          valid_records AS (
            SELECT *
            FROM records
            WHERE form IS NOT NULL
          ),
          invalid_records AS (
            SELECT *
            FROM records
            WHERE form IS NULL
          )

        SELECT election_id, jurisdiction, 1 section, CONCAT(action, ' - ' || gender) AS key, count(*) AS cnt
          FROM valid_records
          GROUP BY election_id, jurisdiction, key
        UNION ALL
        SELECT election_id, jurisdiction, 2 section, CONCAT(action, ' - ' || overseas) AS key, count(*) AS cnt
          FROM valid_records
          GROUP BY election_id, jurisdiction, key

        UNION ALL

        SELECT election_id, jurisdiction, 3 section, CONCAT(action, ' - ' || form, ' - ' || gender) AS key, count(*) AS cnt
          FROM valid_records
          GROUP BY election_id, jurisdiction, key
        UNION ALL
        SELECT election_id, jurisdiction, 4 section, CONCAT(action, ' - ' || form, ' - ' || overseas) AS key, count(*) AS cnt
          FROM valid_records
          GROUP BY election_id, jurisdiction, key

        UNION ALL

        SELECT election_id, jurisdiction, 5 section, CONCAT('Other - ' || gender) AS key, count(*) AS cnt
          FROM invalid_records
          GROUP BY election_id, jurisdiction, key
        UNION ALL
        SELECT election_id, jurisdiction, 6 section, CONCAT('Other - ' || overseas) AS key, count(*) AS cnt
          FROM invalid_records
          GROUP BY election_id, jurisdiction, key

        ORDER BY section, jurisdiction, key;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS events_by_county_by_demog;
      CREATE MATERIALIZED VIEW events_by_county_by_demog AS
        WITH records AS (
            SELECT t.election_id, t.jurisdiction, action, form, COALESCE(gender, 'No gender') AS gender, CASE WHEN overseas = 'f' THEN 'Local' WHEN overseas = 't' THEN 'UOCAVA' ELSE 'No overseas' END AS overseas
            FROM transaction_records t LEFT JOIN demog_records d ON t.voter_id = d.voter_id
            WHERE t.election_id=d.election_id
          ),
          valid_records AS (
            SELECT *
            FROM records
            WHERE form IS NOT NULL
          ),
          invalid_records AS (
            SELECT *
            FROM records
            WHERE form IS NULL
          )

        SELECT election_id, jurisdiction, 1 section, CONCAT(action, ' - ' || gender) AS key, count(*) AS cnt
          FROM valid_records
          GROUP BY election_id, jurisdiction, key
        UNION ALL
        SELECT election_id, jurisdiction, 2 section, CONCAT(action, ' - ' || overseas) AS key, count(*) AS cnt
          FROM valid_records
          GROUP BY election_id, jurisdiction, key

        UNION ALL

        SELECT election_id, jurisdiction, 3 section, CONCAT(action, ' - ' || form, ' - ' || gender) AS key, count(*) AS cnt
          FROM valid_records
          GROUP BY election_id, jurisdiction, key
        UNION ALL
        SELECT election_id, jurisdiction, 4 section, CONCAT(action, ' - ' || form, ' - ' || overseas) AS key, count(*) AS cnt
          FROM valid_records
          GROUP BY election_id, jurisdiction, key

        UNION ALL

        SELECT election_id, jurisdiction, 5 section, CONCAT('Other - ' || gender) AS key, count(*) AS cnt
          FROM invalid_records
          GROUP BY election_id, jurisdiction, key
        UNION ALL
        SELECT election_id, jurisdiction, 6 section, CONCAT('Other - ' || overseas) AS key, count(*) AS cnt
          FROM invalid_records
          GROUP BY election_id, jurisdiction, key

        ORDER BY section, jurisdiction, key;
    }
  end
end
