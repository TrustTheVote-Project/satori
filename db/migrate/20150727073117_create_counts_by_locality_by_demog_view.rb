class CreateCountsByLocalityByDemogView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW counts_by_locality_by_demog AS
        WITH records AS (
            SELECT t.election_id, t.jurisdiction, action, form, COALESCE(gender, 'No gender') AS gender, CASE WHEN overseas = 'f' THEN 'Local' WHEN overseas = 't' THEN 'UOCAVA' ELSE 'No overseas' END AS overseas
            FROM transaction_records t LEFT JOIN demog_records d ON t.voter_id = d.voter_id
            WHERE t.election_id=d.election_id
          )

        SELECT election_id, jurisdiction, 1 section, CONCAT(action, ' - ' || gender) AS key, count(*) AS cnt
          FROM records
          GROUP BY election_id, jurisdiction, key
        UNION ALL
        SELECT election_id, jurisdiction, 2 section, CONCAT(action, ' - ' || overseas) AS key, count(*) AS cnt
          FROM records
          GROUP BY election_id, jurisdiction, key

        UNION ALL

        SELECT election_id, jurisdiction, 3 section, CONCAT(action, ' - ' || form, ' - ' || gender) AS key, count(*) AS cnt
          FROM records
          GROUP BY election_id, jurisdiction, key
        UNION ALL
        SELECT election_id, jurisdiction, 4 section, CONCAT(action, ' - ' || form, ' - ' || overseas) AS key, count(*) AS cnt
          FROM records
          GROUP BY election_id, jurisdiction, key
        ORDER BY section, key;
    }
  end

  def down
    self.connection.execute "DROP MATERIALIZED VIEW IF EXISTS counts_by_locality_by_demog;"
  end
end
