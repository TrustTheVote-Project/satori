class CreateEavsPartAReportView < ActiveRecord::Migration

  def up
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW eavs_part_a_report AS
        WITH localities AS (
            SELECT election_id, jurisdiction
            FROM transaction_records
            GROUP BY election_id, jurisdiction
        )

        SELECT l.election_id, l.jurisdiction,
            COALESCE(t1.total, 0) AS a1a,
            CASE WHEN t1.active > 0 AND t1.inactive > 0 THEN 'Both Active AND Inactive'
                WHEN t1.active > 0 THEN 'Active Only'
                WHEN t1.inactive > 0 THEN 'Inactive Only'
                ELSE 'N/A'
            END AS a2,
            COALESCE(t1.active, 0) AS a3a,
            COALESCE(t1.inactive, 0) AS a3b,

            COALESCE(t2.total, 0) AS a5a,
            COALESCE(t2.new, 0) AS a5b,
            COALESCE(t2.duplicate, 0) AS a5d,
            COALESCE(t2.rejected, 0) AS a5e,
            COALESCE(t2.other, 0) AS a5h,
            COALESCE(t2.total, 0) AS a5_total,

            COALESCE(t3.postal, 0) AS a6a,
            COALESCE(t3.office, 0) AS a6b,
            COALESCE(t3.internet, 0) AS a6c,
            COALESCE(t3.motor_vehicle_office, 0) AS a6d,
            COALESCE(t3.nvra_site, 0) AS a6e,
            COALESCE(t3.advocacy_group, 0) AS a6i,
            COALESCE(t3.other, 0) AS a6j,
            COALESCE(t3.total, 0) AS a6_total,

            COALESCE(t4.postal, 'N/A') AS a7a,
            COALESCE(t4.office, 'N/A') AS a7b,
            COALESCE(t4.internet, 0) AS a7c,
            COALESCE(t4.motor_vehicle_office, 0) AS a7d,
            COALESCE(t4.nvra_site, 0) AS a7e,
            COALESCE(t4.advocacy_group, 0) AS a7i,
            COALESCE(t4.other, 0) AS a7j,
            COALESCE(t4.total, 0) AS a7_total,

            COALESCE(t5.postal, 'N/A') AS a8a,
            COALESCE(t5.office, 'N/A') AS a8b,
            COALESCE(t5.internet, 0) AS a8c,
            COALESCE(t5.motor_vehicle_office, 0) AS a8d,
            COALESCE(t5.nvra_site, 0) AS a8e,
            COALESCE(t5.advocacy_group, 0) AS a8i,
            COALESCE(t5.other, 0) AS a8j,
            COALESCE(t5.total, 0) AS a8_total,

            COALESCE(t6.postal, 0) AS a9a,
            COALESCE(t6.office, 0) AS a9b,
            COALESCE(t6.internet, 0) AS a9c,
            COALESCE(t6.motor_vehicle_office, 0) AS a9d,
            COALESCE(t6.nvra_site, 0) AS a9e,
            COALESCE(t6.advocacy_group, 0) AS a9i,
            COALESCE(t6.other, 0) AS a9j,
            COALESCE(t6.total, 0) AS a9_total,

            COALESCE(t7.total, 0) AS a11a,
            COALESCE(t7.relocation, 0) AS a11b,
            COALESCE(t7.death, 0) AS a11c,
            COALESCE(t7.felony, 0) AS a11d,
            COALESCE(t7.incompetent, 0) AS a11f,
            COALESCE(t7.other, 0) AS a11h,
            COALESCE(t7.total, 0) AS a11_total

        FROM localities l
            LEFT JOIN reg_basic_stats_by_locality t1 ON l.election_id=t1.election_id AND l.jurisdiction=t1.jurisdiction
            LEFT JOIN reg_forms_received_by_locality t2 ON l.election_id=t2.election_id AND l.jurisdiction=t2.jurisdiction
            LEFT JOIN total_reg_by_origin t3 ON l.election_id=t3.election_id AND l.jurisdiction=t3.jurisdiction
            LEFT JOIN new_reg_by_origin t4 ON l.election_id=t4.election_id AND l.jurisdiction=t4.jurisdiction
            LEFT JOIN duplicate_reg_by_origin t5 ON l.election_id=t5.election_id AND l.jurisdiction=t5.jurisdiction
            LEFT JOIN invalid_reg_by_origin t6 ON l.election_id=t6.election_id AND l.jurisdiction=t6.jurisdiction
            LEFT JOIN removed_voters t7 ON l.election_id=t7.election_id AND l.jurisdiction=t7.jurisdiction
        ORDER BY jurisdiction;
    }
  end

  def down
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW eavs_part_a_report;
    }
  end

end
