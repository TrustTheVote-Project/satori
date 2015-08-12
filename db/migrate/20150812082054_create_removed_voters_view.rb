class CreateRemovedVotersView < ActiveRecord::Migration
    def up
      self.connection.execute %Q{
        CREATE MATERIALIZED VIEW removed_voters AS
          WITH cancellations AS (
            SELECT *
            FROM transaction_records
            WHERE action = 'cancelVoterRecord'
          )

          SELECT election_id, jurisdiction,
            COUNT(*) AS total,
            COUNT(*) FILTER (WHERE notes = 'cancelTransferOut') AS relocation,
            COUNT(*) FILTER (WHERE notes = 'cancelDeceased') AS death,
            COUNT(*) FILTER (WHERE notes = 'cancelFelonyConviction') AS felony,
            text 'N/A' AS no_response,
            COUNT(*) FILTER (WHERE notes = 'cancelIncapacitated') AS incompetent,
            text 'N/A' AS by_voter_request,
            COUNT(*) FILTER (WHERE notes IN ('cancelUnderage', 'cancelCitizenship', 'cancelOther')) AS other
          FROM cancellations
          GROUP BY election_id, jurisdiction
      }
    end

    def down
      self.connection.execute %Q{
        DROP MATERIALIZED VIEW IF EXISTS removed_voters;
      }
    end
end
