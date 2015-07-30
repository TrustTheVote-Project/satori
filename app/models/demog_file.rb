class DemogFile < ActiveRecord::Base

  belongs_to :account
  belongs_to :election
  belongs_to :uploader, class_name: 'User'
  has_many   :records, class_name: 'DemogRecord', dependent: :delete_all

  before_validation :init_account

  validates :filename, presence: true
  validates :origin, presence: true
  validates :hash_alg, presence: true
  validates :create_date, presence: true

  def recalculate_stats!
    self.records_count = self.records.count
    save!
  end

  private

  def init_account
    self.account_id = self.election.account_id unless self.election.nil?
  end

end
