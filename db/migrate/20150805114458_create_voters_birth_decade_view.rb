class CreateVotersBirthDecadeView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW voters_birth_decade AS
        SELECT election_id, jurisdiction, year_of_birth / 10 AS decade, COUNT(*) cnt
        FROM demog_records
        GROUP BY election_id, jurisdiction, decade
        ORDER BY jurisdiction;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS voters_birth_decade;
    }
  end
end
