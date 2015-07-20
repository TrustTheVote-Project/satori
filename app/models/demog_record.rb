class DemogRecord < ActiveRecord::Base

  belongs_to :account
  belongs_to :election
  belongs_to :file, class_name: 'DemogFile', foreign_key: 'demog_file_id'

  before_validation :init_election
  before_validation :init_account

  # sets attributes from the record Demog
  def set_attributes_from_demog(rec)
    self.voter_id                  = rec.voter_id
    self.jurisdiction              = rec.jurisdiction
    self.reg_date                  = rec.reg_date
    self.year_of_birth             = rec.year_of_birth
    self.reg_status                = rec.reg_status
    self.gender                    = rec.gender
    self.race                      = rec.race
    self.political_party_name      = rec.political_party_name
    self.overseas                  = rec.overseas
    self.military                  = rec.military
    self.protected                 = rec.protected
    self.disabled                  = rec.disabled
    self.absentee_ongoing          = rec.absentee_ongoing
    self.absentee_in_this_election = rec.absentee_in_this_election
    self.precinct_split_id         = rec.precinct_split_id
    self.zip_code                  = rec.zip_code
  end

  private

  def init_election
    self.election_id ||= file.try(:election_id)
  end

  def init_account
    self.account_id ||= self.election.account_id unless self.election.nil?
  end

end
