# This migration comes from tenet_engine (originally 20140813085604)
class CreateCsfSettings < ActiveRecord::Migration
  def change
    create_table :csf_settings do |t|
      t.string :name, null: false
      t.text   :value
      t.timestamps
    end

    add_index :csf_settings, :name, unique: true
  end
end
