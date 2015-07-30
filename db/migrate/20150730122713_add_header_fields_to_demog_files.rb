class AddHeaderFieldsToDemogFiles < ActiveRecord::Migration
  def change
    DemogFile.destroy_all
    add_column :demog_files, :origin, :string, null: false
    add_column :demog_files, :origin_uniq, :string
    add_column :demog_files, :create_date, :datetime, null: false
    add_column :demog_files, :hash_alg, :string, null: false
  end
end
