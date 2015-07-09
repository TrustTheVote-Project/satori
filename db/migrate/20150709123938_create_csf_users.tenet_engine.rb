# This migration comes from tenet_engine (originally 20140620025125)
class CreateCsfUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.belongs_to :account, null: false, index: true

      t.string     :login, null: false, unique: true
      t.string     :crypted_password, null: false
      t.string     :salt, null: false

      t.string     :first_name, null: false
      t.string     :last_name, null: false
      t.string     :email, null: false
      t.boolean    :admin, null: false, default: false

      t.timestamps
    end
  end
end
