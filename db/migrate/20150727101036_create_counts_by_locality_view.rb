class CreateCountsByLocalityView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW counts_by_locality AS
        SELECT election_id, jurisdiction, 1 section, CONCAT(action, ' - ', form) AS key, COUNT(*) AS cnt
        FROM transaction_records
        WHERE form IS NOT NULL
        GROUP BY election_id, jurisdiction, key

        UNION ALL

        SELECT election_id, jurisdiction, 2 section, 'Other' AS key, COUNT(*) AS cnt
        FROM transaction_records
        WHERE form IS NULL
        GROUP BY election_id, jurisdiction, key

        ORDER BY section, jurisdiction, key;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS counts_by_locality;
    }
  end
end
