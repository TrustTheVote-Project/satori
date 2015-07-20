class CreateUploadJobs < ActiveRecord::Migration
  def change
    create_table :upload_jobs do |t|
      t.string :uuid, null: false
      t.belongs_to :election, index: true, foreign_key: true
      t.string :url, null: false
      t.string :kind, null: false
      t.string :state, null: false
      t.integer :progress, null: false, default: 0
      t.string :error

      t.timestamps null: false
    end

    add_index :upload_jobs, :uuid
  end
end
