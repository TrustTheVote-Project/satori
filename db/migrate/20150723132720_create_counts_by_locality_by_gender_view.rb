class CreateCountsByLocalityByGenderView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW counts_by_locality_by_gender AS
        SELECT t.election_id, t.jurisdiction, concat(action, ' - ' || form, ' - ' || gender) AS key, count(*) AS cnt
        FROM transaction_records t LEFT JOIN demog_records d ON t.voter_id = d.voter_id
        WHERE t.election_id=d.election_id
        GROUP BY t.election_id, t.jurisdiction, key;
    }
  end

  def down
    self.connection.execute "DROP MATERIALIZED VIEW IF EXISTS counts_by_locality_by_gender;"
  end
end
