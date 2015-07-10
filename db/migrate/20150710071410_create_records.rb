class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.belongs_to :log, index: true, foreign_key: true
      t.string :voter_id, null: false
      t.datetime :recorded_at, null: false
      t.string :action, null: false
      t.string :jurisdiction, null: false
      t.string :form
      t.string :form_note
      t.string :leo
      t.string :notes
      t.string :comment

      t.timestamps null: false
    end
  end
end
