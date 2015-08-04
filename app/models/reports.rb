class Reports

  def self.refresh
    query = <<-SQL
      REFRESH MATERIALIZED VIEW events_by_locality;
      REFRESH MATERIALIZED VIEW events_by_county_by_demog;
      REFRESH MATERIALIZED VIEW events_by_county;
    SQL
      # REFRESH MATERIALIZED VIEW events_by_locality_by_demog;
    ActiveRecord::Base.connection.execute(query)
  end

end
