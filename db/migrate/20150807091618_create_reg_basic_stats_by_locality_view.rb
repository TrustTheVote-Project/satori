class CreateRegBasicStatsByLocalityView < ActiveRecord::Migration
    def up
      self.connection.execute %Q{
        CREATE MATERIALIZED VIEW reg_basic_stats_by_locality AS
          SELECT election_id, jurisdiction,
            COUNT(DISTINCT voter_id) AS total,
            COUNT(DISTINCT voter_id) FILTER (WHERE reg_status = 'Active') AS active,
            COUNT(DISTINCT voter_id) FILTER (WHERE reg_status = 'Inactive') AS inactive
            FROM demog_records
            GROUP BY election_id, jurisdiction
      }
    end

    def down
      self.connection.execute %Q{
        DROP MATERIALIZED VIEW IF EXISTS reg_basic_stats_by_locality;
      }
    end
end
