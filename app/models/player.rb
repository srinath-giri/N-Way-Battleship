class Player < ActiveRecord::Base
  attr_accessible :name, :turn

  validates_presence_of :name
end
