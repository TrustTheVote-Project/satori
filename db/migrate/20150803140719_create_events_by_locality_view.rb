class CreateEventsByLocalityView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW events_by_locality AS
        SELECT election_id, jurisdiction, 1 section, CONCAT(action, ' - ', form) AS key, COUNT(*) AS cnt
        FROM transaction_records
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
