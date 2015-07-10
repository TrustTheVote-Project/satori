class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :name
      t.date :held_on
      t.date :voter_start_on
      t.date :voter_end_on
      t.date :reg_deadline_on
      t.date :ab_req_deadline_on
      t.date :ab_rec_deadline_on
      t.date :ffd_deadline_on

      t.timestamps null: false
    end
  end
end
