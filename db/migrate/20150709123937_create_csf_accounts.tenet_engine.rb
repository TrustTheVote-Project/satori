# This migration comes from tenet_engine (originally 20140620024707)
class CreateCsfAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :state, index: true
      t.string :name

      t.timestamps
    end
  end
end
