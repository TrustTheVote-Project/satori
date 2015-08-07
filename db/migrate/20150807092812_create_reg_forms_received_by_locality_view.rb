class CreateRegFormsReceivedByLocalityView < ActiveRecord::Migration
    def up
      self.connection.execute %Q{
        CREATE MATERIALIZED VIEW reg_forms_received_by_locality AS
          WITH reg_forms AS (
            SELECT *
            FROM transaction_records
            WHERE form IN ('VoterRegistration', 'VoterRegistrationAbsenteeRequest', 'VoterRecordUpdate', 'VoterRecordUpdateAbsenteeRequest')
          ),

          reg_forms_received AS (
            SELECT *
            FROM reg_forms
            WHERE action IN ('approve', 'reject')
          ),

          reg_forms_other_stats AS (
            SELECT election_id, jurisdiction, COUNT(*) AS other
            FROM reg_forms
            WHERE action NOT IN ('approve', 'reject') AND
                  recorded_at > date_trunc('year', now()) - INTERVAL '1 year'
            GROUP BY election_id, jurisdiction
          ),

          reg_changes_received AS (
            SELECT election_id, jurisdiction, COUNT(*) AS changes
            FROM transaction_records
            WHERE action IN ('approve', 'reject') AND
                  form IN ('VoterRecordUpdate', 'VoterRecordUpdateAbsenteeRequest') AND
                  recorded_at > date_trunc('year', now()) - INTERVAL '1 year'
            GROUP BY election_id, jurisdiction
          ),

          reg_forms_received_part_stats AS (
            SELECT election_id, jurisdiction,
              COUNT(*) AS total,
              COUNT(*) FILTER (WHERE notes = 'acceptNewRequest') AS new,
              COUNT(*) FILTER (WHERE notes IN ('acceptDuplicate', 'cancelDuplicate')) AS duplicate,
              COUNT(*) FILTER (WHERE notes LIKE 'reject%') AS rejected
            FROM reg_forms_received
            WHERE recorded_at > date_trunc('year', now()) - INTERVAL '1 year'
            GROUP BY election_id, jurisdiction
          )

          SELECT s.*, COALESCE(c.changes, 0) AS record_changes, COALESCE(o.other, 0) AS other
          FROM reg_forms_received_part_stats s
            LEFT JOIN reg_changes_received c ON s.election_id=c.election_id AND s.jurisdiction=c.jurisdiction
            LEFT JOIN reg_forms_other_stats o ON s.election_id=o.election_id AND s.jurisdiction=o.jurisdiction

      }
    end

    def down
      self.connection.execute %Q{
        DROP MATERIALIZED VIEW IF EXISTS reg_forms_received_by_locality;
      }
    end
end
