class RenameReportViews < ActiveRecord::Migration

  def up
    self.connection.execute %Q{
      ALTER MATERIALIZED VIEW counts_by_locality RENAME TO events_by_county;
      ALTER MATERIALIZED VIEW counts_by_locality_by_demog RENAME TO events_by_county_by_demog;
    }
  end

  def down
    self.connection.execute %Q{
      ALTER MATERIALIZED VIEW events_by_county RENAME TO counts_by_locality;
      ALTER MATERIALIZED VIEW events_by_county_by_demog RENAME TO counts_by_locality_by_demog;
    }
  end

end
