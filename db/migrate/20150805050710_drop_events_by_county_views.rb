class DropEventsByCountyViews < ActiveRecord::Migration
  def up
    self.connection.execute %Q{
      DROP MATERIALIZED VIEW IF EXISTS events_by_county, events_by_county_by_demog;
    }
  end

  def down
    self.connection.execute %Q{
      CREATE MATERIALIZED VIEW events_by_county AS
       SELECT transaction_records.election_id,
          transaction_records.jurisdiction,
          1 AS section,
          concat(transaction_records.action, ' - ', transaction_records.form) AS key,
          count(*) AS cnt
         FROM transaction_records
        WHERE (transaction_records.form IS NOT NULL)
        GROUP BY transaction_records.election_id, transaction_records.jurisdiction, concat(transaction_records.action, ' - ', transaction_records.form)
      UNION ALL
       SELECT transaction_records.election_id,
          transaction_records.jurisdiction,
          2 AS section,
          'Other'::text AS key,
          count(*) AS cnt
         FROM transaction_records
        WHERE (transaction_records.form IS NULL)
        GROUP BY transaction_records.election_id, transaction_records.jurisdiction, 'Other'::text
        ORDER BY 3, 2, 4
        WITH NO DATA;


      CREATE MATERIALIZED VIEW events_by_county_by_demog AS
       WITH records AS (
               SELECT t.election_id,
                  t.jurisdiction,
                  t.action,
                  t.form,
                  COALESCE(d.gender, 'No gender'::character varying) AS gender,
                      CASE
                          WHEN ((d.overseas = true) OR (d.military = true)) THEN 'UOCAVA'::text
                          ELSE 'Local'::text
                      END AS overseas
                 FROM (transaction_records t
                   LEFT JOIN demog_records d ON (((t.voter_id)::text = (d.voter_id)::text)))
                WHERE (t.election_id = d.election_id)
              ), valid_records AS (
               SELECT records.election_id,
                  records.jurisdiction,
                  records.action,
                  records.form,
                  records.gender,
                  records.overseas
                 FROM records
                WHERE (records.form IS NOT NULL)
              ), invalid_records AS (
               SELECT records.election_id,
                  records.jurisdiction,
                  records.action,
                  records.form,
                  records.gender,
                  records.overseas
                 FROM records
                WHERE (records.form IS NULL)
              )
       SELECT valid_records.election_id,
          valid_records.jurisdiction,
          1 AS section,
          concat(valid_records.action, (' - '::text || (valid_records.gender)::text)) AS key,
          count(*) AS cnt
         FROM valid_records
        GROUP BY valid_records.election_id, valid_records.jurisdiction, concat(valid_records.action, (' - '::text || (valid_records.gender)::text))
      UNION ALL
       SELECT valid_records.election_id,
          valid_records.jurisdiction,
          2 AS section,
          concat(valid_records.action, (' - '::text || valid_records.overseas)) AS key,
          count(*) AS cnt
         FROM valid_records
        GROUP BY valid_records.election_id, valid_records.jurisdiction, concat(valid_records.action, (' - '::text || valid_records.overseas))
      UNION ALL
       SELECT valid_records.election_id,
          valid_records.jurisdiction,
          3 AS section,
          concat(valid_records.action, (' - '::text || (valid_records.form)::text), (' - '::text || (valid_records.gender)::text)) AS key,
          count(*) AS cnt
         FROM valid_records
        GROUP BY valid_records.election_id, valid_records.jurisdiction, concat(valid_records.action, (' - '::text || (valid_records.form)::text), (' - '::text || (valid_records.gender)::text))
      UNION ALL
       SELECT valid_records.election_id,
          valid_records.jurisdiction,
          4 AS section,
          concat(valid_records.action, (' - '::text || (valid_records.form)::text), (' - '::text || valid_records.overseas)) AS key,
          count(*) AS cnt
         FROM valid_records
        GROUP BY valid_records.election_id, valid_records.jurisdiction, concat(valid_records.action, (' - '::text || (valid_records.form)::text), (' - '::text || valid_records.overseas))
      UNION ALL
       SELECT invalid_records.election_id,
          invalid_records.jurisdiction,
          5 AS section,
          concat(('Other - '::text || (invalid_records.gender)::text)) AS key,
          count(*) AS cnt
         FROM invalid_records
        GROUP BY invalid_records.election_id, invalid_records.jurisdiction, concat(('Other - '::text || (invalid_records.gender)::text))
      UNION ALL
       SELECT invalid_records.election_id,
          invalid_records.jurisdiction,
          6 AS section,
          concat(('Other - '::text || invalid_records.overseas)) AS key,
          count(*) AS cnt
         FROM invalid_records
        GROUP BY invalid_records.election_id, invalid_records.jurisdiction, concat(('Other - '::text || invalid_records.overseas))
        ORDER BY 3, 2, 4
        WITH NO DATA;
    }
  end
end
