class Election < ActiveRecord::Base

  belongs_to :account
  has_many :logs, dependent: :destroy
  has_many :records

  validates :account, presence: true
  validates :name, presence: true

end
