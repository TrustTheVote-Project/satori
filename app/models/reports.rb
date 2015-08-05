class Reports

  def self.refresh
    ActiveRecord::Base.connection.execute <<-SQL
      REFRESH MATERIALIZED VIEW events_by_locality;
      REFRESH MATERIALIZED VIEW events_by_locality_by_uocava;
      REFRESH MATERIALIZED VIEW events_by_locality_by_gender;
      REFRESH MATERIALIZED VIEW voter_demographics_by_locality;
    SQL
  end

end
