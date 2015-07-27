class Reports

  def self.refresh
    query = <<-SQL
      REFRESH MATERIALIZED VIEW counts_by_locality_by_demog;
      REFRESH MATERIALIZED VIEW counts_by_locality;
    SQL
    ActiveRecord::Base.connection.execute(query)
  end

end
