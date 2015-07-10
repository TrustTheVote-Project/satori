class Log < ActiveRecord::Base

  belongs_to :election
  has_many   :records, dependent: :delete_all

  validates :filename, presence: true
  validates :origin, presence: true
  validates :hash_alg, presence: true
  validates :create_date, presence: true

  # sets attributes from VTL log record
  def set_attributes_from_vtl(log)
    self.origin      = log.origin
    self.origin_uniq = log.origin_uniq
    self.create_date = log.create_date
    self.hash_alg    = log.hash_alg
  end

end