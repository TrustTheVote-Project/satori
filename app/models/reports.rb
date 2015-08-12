class Reports

  def self.refresh
    ActiveRecord::Base.connection.execute <<-SQL
      REFRESH MATERIALIZED VIEW events_by_locality;
      REFRESH MATERIALIZED VIEW events_by_locality_by_uocava;
      REFRESH MATERIALIZED VIEW events_by_locality_by_gender;
      REFRESH MATERIALIZED VIEW voter_demographics_by_locality;
      REFRESH MATERIALIZED VIEW voters_race;
      REFRESH MATERIALIZED VIEW voters_party;
      REFRESH MATERIALIZED VIEW voters_birth_decade;
      REFRESH MATERIALIZED VIEW cancellation_reasons_by_locality;
      REFRESH MATERIALIZED VIEW reg_rejection_reasons_by_locality;
      REFRESH MATERIALIZED VIEW ballot_rejection_reasons_by_locality;
      REFRESH MATERIALIZED VIEW reg_forms_received_by_locality;
      REFRESH MATERIALIZED VIEW reg_basic_stats_by_locality;
      REFRESH MATERIALIZED VIEW total_reg_by_origin;
      REFRESH MATERIALIZED VIEW new_reg_by_origin;
      REFRESH MATERIALIZED VIEW duplicate_reg_by_origin;
      REFRESH MATERIALIZED VIEW invalid_reg_by_origin;
      REFRESH MATERIALIZED VIEW removed_voters;
    SQL
  end

end
