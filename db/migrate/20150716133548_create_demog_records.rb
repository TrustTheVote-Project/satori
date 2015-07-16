class CreateDemogRecords < ActiveRecord::Migration
  def change
    create_table :demog_records do |t|
      t.belongs_to :demog_file, index: true, foreign_key: true
      t.belongs_to :election, index: true, foreign_key: true
      t.belongs_to :account,  index: true, foreign_key: true
      t.string :voter_id
      t.string :jurisdiction
      t.date :reg_date
      t.integer :year_of_birth
      t.string :reg_status
      t.string :gender
      t.string :race
      t.string :political_party_name
      t.boolean :overseas
      t.boolean :military
      t.boolean :protected
      t.boolean :disabled
      t.boolean :absentee_ongoing
      t.boolean :absentee_in_this_election
      t.string :precinct_split_id
      t.string :zip_code
    end
  end
end
