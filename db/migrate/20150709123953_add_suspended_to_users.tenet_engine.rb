# This migration comes from tenet_engine (originally 20141110092124)
class AddSuspendedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suspended, :boolean, null: false, default: false
    add_index  :users, :suspended
  end
end
