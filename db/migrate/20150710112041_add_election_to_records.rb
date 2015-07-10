class AddElectionToRecords < ActiveRecord::Migration
  def change
    add_reference :records, :election, index: true, foreign_key: true
  end
end
