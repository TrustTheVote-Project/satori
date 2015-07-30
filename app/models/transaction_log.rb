class TransactionLog < ActiveRecord::Base

  belongs_to :account
  belongs_to :election
  belongs_to :uploader, class_name: 'User'
  has_many   :records, foreign_key: 'log_id', class_name: 'TransactionRecord', dependent: :delete_all

  validates :account, presence: true
  validates :filename, presence: true
  validates :origin, presence: true
  validates :hash_alg, presence: true
  validates :create_date, presence: true

  before_validation :init_account

  # sets attributes from VTL log record
  def set_attributes_from_vtl(log)
    self.origin      = log.origin
    self.origin_uniq = log.origin_uniq
    self.create_date = log.create_date
    self.hash_alg    = log.hash_alg
  end

  def recalculate_stats!
    ordered_records = self.records.order(:recorded_at)
    self.earliest_event_at = ordered_records.first.try(:recorded_at)
    self.latest_event_at   = ordered_records.last.try(:recorded_at)
    self.events_count      = self.records.count
    save!
  end

  private

  def init_account
    self.account_id = self.election.account_id unless self.election.nil?
  end

end
