class Reports

  def self.refresh
    ActiveRecord::Base.connection.execute <<-SQL
      REFRESH MATERIALIZED VIEW events_by_locality;
      REFRESH MATERIALIZED VIEW events_by_county_by_demog;
      REFRESH MATERIALIZED VIEW events_by_county;
      REFRESH MATERIALIZED VIEW events_by_locality_by_uocava;
    SQL
  end

end
