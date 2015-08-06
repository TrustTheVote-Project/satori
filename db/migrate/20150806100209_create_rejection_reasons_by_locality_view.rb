class CreateRejectionReasonsByLocalityView < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW reg_rejection_reasons_by_locality AS
        SELECT election_id, jurisdiction, 'Registered Voters' AS key, COUNT(*) AS cnt
          FROM demog_records
          GROUP BY election_id, jurisdiction

        UNION ALL

        SELECT election_id, jurisdiction, 'Rejected VR or AB Requests' AS key, COUNT(*) cnt
          FROM transaction_records
          WHERE action = 'reject' AND form IN ('VoterRegistration', 'VoterRegistrationAbsenteeRequest', 'VoterRecordUpdate', 'VoterRecordUpdateAbsenteeRequest', 'AbsenteeRequest')
          GROUP BY election_id, jurisdiction

        UNION ALL

        SELECT election_id, jurisdiction, notes AS key, COUNT(*) cnt
          FROM transaction_records
          WHERE action = 'reject' AND notes IN ('rejectLate', 'rejectUnsigned', 'rejectIncomplete', 'rejectFelonyConviction', 'rejectIncapacitated', 'rejectUnderage', 'rejectCitizenship')
          GROUP BY election_id, jurisdiction, notes

        UNION ALL

        SELECT election_id, jurisdiction, 'Other' AS key, COUNT(*) cnt
          FROM transaction_records
          WHERE action = 'reject' AND form IN ('VoterRegistration', 'VoterRegistrationAbsenteeRequest', 'VoterRecordUpdate', 'VoterRecordUpdateAbsenteeRequest', 'AbsenteeRequest') AND notes IS NULL
          GROUP BY election_id, jurisdiction

        ORDER BY jurisdiction;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS reg_rejection_reasons_by_locality;
    }
  end
end
