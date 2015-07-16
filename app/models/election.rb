class Election < ActiveRecord::Base

  belongs_to :account
  has_many :transaction_logs, dependent: :destroy
  has_many :demog_files, dependent: :destroy
  has_many :records, class_name: 'TransactionRecord'
  has_many :voters, class_name: 'DemogRecord'

  validates :account, presence: true
  validates :name, presence: true

end
