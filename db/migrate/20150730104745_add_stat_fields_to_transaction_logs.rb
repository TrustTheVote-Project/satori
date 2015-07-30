class AddStatFieldsToTransactionLogs < ActiveRecord::Migration
  def change
    add_column :transaction_logs, :uploaded_at, :datetime
    add_column :transaction_logs, :uploader_id, :integer
    add_column :transaction_logs, :earliest_event_at, :datetime
    add_column :transaction_logs, :latest_event_at, :datetime
    add_column :transaction_logs, :events_count, :integer
  end
end
