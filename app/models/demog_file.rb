class DemogFile < ActiveRecord::Base

  belongs_to :account
  belongs_to :election
  has_many   :records, class_name: 'DemogRecord', dependent: :delete_all

  before_validation :init_account

  private

  def init_account
    self.account_id = self.election.account_id unless self.election.nil?
  end

end
