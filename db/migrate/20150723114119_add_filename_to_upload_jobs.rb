class AddFilenameToUploadJobs < ActiveRecord::Migration
  def change
    add_column :upload_jobs, :filename, :string
  end
end
