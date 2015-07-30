class Election < ActiveRecord::Base

  belongs_to :account
  belongs_to :owner, class_name: 'User'

  has_many :transaction_logs, dependent: :destroy
  has_many :demog_files, dependent: :destroy
  has_many :records, class_name: 'TransactionRecord'
  has_many :voters, class_name: 'DemogRecord'
  has_many :upload_jobs, dependent: :nullify

  validates :account, presence: true
  validates :name, presence: true

end
