class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.belongs_to :election, index: true, foreign_key: true
      t.string :origin, null: false
      t.string :origin_uniq
      t.datetime :create_date, null: false
      t.string :hash_alg, null: false
      t.string :filename
      t.integer :records_count, default: 0

      t.timestamps null: false
    end
  end
end
