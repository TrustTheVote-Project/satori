# This migration comes from tenet_engine (originally 20140718082106)
class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
  end
end
