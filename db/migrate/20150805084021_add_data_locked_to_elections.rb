class AddDataLockedToElections < ActiveRecord::Migration
  def change
    add_column :elections, :data_locked, :boolean
  end
end
