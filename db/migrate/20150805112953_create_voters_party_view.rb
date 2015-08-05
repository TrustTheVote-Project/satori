class CreateVotersPartyView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW voters_party AS
        SELECT election_id, jurisdiction, political_party_name, COUNT(*) AS cnt
        FROM demog_records
        GROUP BY election_id, jurisdiction, political_party_name
        ORDER BY jurisdiction, political_party_name;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS voters_party;
    }
  end
end
