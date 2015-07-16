class CreateDemogFiles < ActiveRecord::Migration
  def change
    create_table :demog_files do |t|
      t.belongs_to :election, index: true, foreign_key: true
      t.belongs_to :account,  index: true, foreign_key: true
      t.string     :filename, null: false

      t.timestamps null: false
    end
  end
end
