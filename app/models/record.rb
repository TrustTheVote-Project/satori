class Record < ActiveRecord::Base

  belongs_to :account
  belongs_to :election
  belongs_to :log

  validates :account, presence: true

  before_validation :init_election
  before_validation :init_account

  # sets attributes from the record VTL
  def set_attributes_from_vtl(rec)
    self.voter_id     = rec.voter_id
    self.recorded_at  = rec.date
    self.action       = rec.action
    self.jurisdiction = rec.jurisdiction
    self.form         = rec.form
    self.form_note    = rec.form_note
    self.leo          = rec.leo
    self.notes        = rec.notes
    self.comment      = rec.comment
  end

  private

  def init_election
    self.election ||= log.try(:election)
  end

  def init_account
    self.account_id = self.election.account_id unless self.election.nil?
  end

end
