# This migration comes from tenet_engine (originally 20140620111207)
class AddProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :title, :string
  end
end
