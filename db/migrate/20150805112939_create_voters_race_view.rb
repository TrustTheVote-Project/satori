class CreateVotersRaceView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW voters_race AS
        SELECT election_id, jurisdiction, race, COUNT(*) AS cnt
        FROM demog_records
        GROUP BY election_id, jurisdiction, race
        ORDER BY jurisdiction, race;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS voters_race;
    }
  end
end
