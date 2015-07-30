class AddStatFieldsToDemogFiles < ActiveRecord::Migration
  def change
    add_column :demog_files, :uploaded_at, :datetime
    add_column :demog_files, :uploader_id, :integer
    add_column :demog_files, :records_count, :integer
  end
end
