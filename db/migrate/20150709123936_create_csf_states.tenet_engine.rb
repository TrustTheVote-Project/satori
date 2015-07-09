# This migration comes from tenet_engine (originally 20140620024616)
class CreateCsfStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false
    end
  end
end
