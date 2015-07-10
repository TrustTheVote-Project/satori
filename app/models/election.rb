class Election < ActiveRecord::Base

  has_many :logs, dependent: :destroy
  has_many :records

  validates :name, presence: true

end
