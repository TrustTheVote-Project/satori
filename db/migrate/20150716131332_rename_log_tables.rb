class RenameLogTables < ActiveRecord::Migration
  def change
    rename_table :logs, :transaction_logs
    rename_table :records, :transaction_records
  end
end
