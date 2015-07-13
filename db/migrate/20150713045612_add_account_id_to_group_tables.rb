class AddAccountIdToGroupTables < ActiveRecord::Migration
  def change
    %w{ elections logs records }.each do |table|
      add_column table, :account_id, :integer
      add_index  table, :account_id
      add_foreign_key table, 'accounts'
    end

    acc = Account.last
    Election.update_all(account_id: acc.id)
    Log.update_all(account_id: acc.id)
    Record.update_all(account_id: acc.id)
  end
end
