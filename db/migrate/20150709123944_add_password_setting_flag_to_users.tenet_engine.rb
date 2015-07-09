# This migration comes from tenet_engine (originally 20140716195158)
class AddPasswordSettingFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_set, :boolean, null: false, default: false
  end
end
