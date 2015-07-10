class Election < ActiveRecord::Base

  has_many :logs, dependent: :destroy

  validates :name, presence: true

end
