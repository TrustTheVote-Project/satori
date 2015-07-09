# This migration comes from tenet_engine (originally 20140717100232)
class ChangeAdmingNameToFirstLast < ActiveRecord::Migration
  def change
    add_column :registration_requests, :admin_first_name, :string
    add_column :registration_requests, :admin_last_name, :string
    remove_column :registration_requests, :admin_name
  end
end
