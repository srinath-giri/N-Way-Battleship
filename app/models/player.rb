class Player < ActiveRecord::Base
  attr_accessible :name, :turn

  validates :name, presence: true
end
