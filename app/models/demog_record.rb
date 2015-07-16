class DemogRecord < ActiveRecord::Base

  belongs_to :account
  belongs_to :election
  belongs_to :file, class_name: 'DemogFile', foreign_key: 'demog_file_id'

  before_validation :init_election
  before_validation :init_account

  private

  def init_election
    self.election_id ||= file.try(:election_id)
  end

  def init_account
    self.account_id ||= self.election.account_id unless self.election.nil?
  end

end
