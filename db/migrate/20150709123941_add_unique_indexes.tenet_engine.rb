# This migration comes from tenet_engine (originally 20140620110642)
class AddUniqueIndexes < ActiveRecord::Migration
  def change
    add_index :accounts, :name, unique: true
    add_index :users, :login, unique: true
  end
end
