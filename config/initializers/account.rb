Account.class_eval do

  has_many :elections, dependent: :destroy

end
