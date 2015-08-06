class CreateBallotRejectionReasonsByLocalityView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW ballot_rejection_reasons_by_locality AS
        SELECT election_id, jurisdiction, 'Registered Voters' AS key, COUNT(*) AS cnt
          FROM demog_records
          GROUP BY election_id, jurisdiction

        UNION ALL

        SELECT election_id, jurisdiction, CONCAT(form, ' - Accepted') AS key, COUNT(*) cnt
          FROM transaction_records
          WHERE action = 'approve' AND form IN ('AbsenteeBallot', 'ProvisionalBallot')
          GROUP BY election_id, jurisdiction, key

        UNION ALL

        SELECT election_id, jurisdiction, CONCAT(form, ' - Rejected') AS key, COUNT(*) cnt
          FROM transaction_records
          WHERE action = 'reject' AND form IN ('AbsenteeBallot', 'ProvisionalBallot')
          GROUP BY election_id, jurisdiction, key

        UNION ALL

        SELECT election_id, jurisdiction, CONCAT(form, ' - ', COALESCE(notes, 'Other')) AS key, COUNT(*) cnt
          FROM transaction_records
          WHERE notes LIKE 'reject%' AND form IN ('AbsenteeBallot', 'ProvisionalBallot')
          GROUP BY election_id, jurisdiction, key

        ORDER BY jurisdiction;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS ballot_rejection_reasons_by_locality;
    }
  end
end
