class CreateCancellationReasonsByLocalityView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW cancellation_reasons_by_locality AS
        SELECT election_id, jurisdiction, 'Registered Voters' AS key, COUNT(*) AS cnt
          FROM demog_records
          GROUP BY election_id, jurisdiction

        UNION ALL

        SELECT election_id, jurisdiction, 'Cancellations' AS key, COUNT(*) cnt
          FROM transaction_records
          WHERE action = 'cancelVoterRecord'
          GROUP BY election_id, jurisdiction

        UNION ALL

        SELECT election_id, jurisdiction, COALESCE(notes, 'Other') AS key, COUNT(*) cnt
          FROM transaction_records
          WHERE action = 'cancelVoterRecord'
          GROUP BY election_id, jurisdiction, notes

        ORDER BY jurisdiction;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS cancellation_reasons_by_locality;
    }
  end
end
