class Player < ActiveRecord::Base
  attr_accessible :name, :turn

  validates :name, presence: true
  validates :name, uniqueness: true

end
