class UploadJob < ActiveRecord::Base

  PENDING    = 'pending'
  PROCESSING = 'processing'
  FINISHED   = 'finished'
  STATES     = [ PENDING, PROCESSING, FINISHED ]

  VTL        = "vtl"
  DEMOG      = "demog"
  KINDS      = [ VTL, DEMOG ]

  belongs_to :election

  validates :uuid, presence: true
  validates :url, presence: true
  validates :state, inclusion: { in: STATES }

  before_validation :init_uuid

  scope :active,  -> { where(state: [ PENDING, PROCESSING ]) }
  scope :vtl,     -> { where(kind: VTL) }
  scope :demog,   -> { where(kind: DEMOG) }
  scope :errors,  -> { where('state = ? AND error IS NOT NULL', FINISHED) }

  def start!
    self.state = PROCESSING
    save!
  end

  def finish!
    self.state = FINISHED
    save!
  end

  def abort!(error)
    self.state = FINISHED
    self.error = error
    save!
  end

  private

  def init_uuid
    self.uuid ||= SecureRandom.uuid
  end

end
