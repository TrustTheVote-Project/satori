class Reports

  def self.refresh
    query = <<-SQL
      REFRESH MATERIALIZED VIEW counts_by_locality_by_gender;
      REFRESH MATERIALIZED VIEW counts_by_locality_by_uocava;
    SQL
    ActiveRecord::Base.connection.execute(query)
  end

end
