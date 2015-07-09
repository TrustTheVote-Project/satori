# This migration comes from tenet_engine (originally 20140812075203)
class AddOtpFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ssh_public_key, :text
    add_index  :users, :ssh_public_key, unique: true
  end
end
