class CreateNewRegByOriginView < ActiveRecord::Migration
    def up
      self.connection.execute %Q{
        CREATE MATERIALIZED VIEW new_reg_by_origin AS
          WITH registrations AS (
            SELECT *
            FROM transaction_records
            WHERE action = 'approve' AND
                  notes  = 'acceptNewRequest' AND
                  form IN ('VoterRegistration', 'VoterRegistrationAbsenteeRequest', 'VoterRecordUpdate', 'VoterRecordUpdateAbsenteeRequest')
          )

          SELECT election_id, jurisdiction,
              COUNT(*) as total,
              text 'N/A' AS office,
              text 'N/A' AS postal,
              COUNT(*) FILTER (WHERE form_note IN ('onlineGeneratedPaperless', 'onlineGeneratedPaper')) AS internet,
              COUNT(*) FILTER (WHERE form_note = 'NVRAmotorVehicles') AS motor_vehicle_office,
              COUNT(*) FILTER (WHERE form_note = 'NVRAother') AS nvra_site,
              COUNT(*) FILTER (WHERE form_note = 'thirdParty') AS advocacy_group,
              COUNT(*) FILTER (WHERE form_note IS NULL AND notes IS null) AS other
          FROM registrations
          GROUP BY election_id, jurisdiction
      }
    end

    def down
      self.connection.execute %Q{
        DROP MATERIALIZED VIEW IF EXISTS new_reg_by_origin ;
      }
    end
end
