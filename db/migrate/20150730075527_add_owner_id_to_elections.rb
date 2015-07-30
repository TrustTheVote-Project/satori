class AddOwnerIdToElections < ActiveRecord::Migration
  def change
    add_column :elections, :owner_id, :integer
    add_index  :elections, :owner_id
  end
end
