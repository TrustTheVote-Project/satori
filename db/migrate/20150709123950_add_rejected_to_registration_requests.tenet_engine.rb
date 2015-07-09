# This migration comes from tenet_engine (originally 20141110073136)
class AddRejectedToRegistrationRequests < ActiveRecord::Migration
  def change
    add_column :registration_requests, :rejected, :boolean, null: false, default: false
  end
end
