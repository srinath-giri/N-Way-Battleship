class Ship < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of(:name)
  validates_inclusion_of :name, :in => %w( Destroyer Battleship Carrier Submarine PatrolBoat)

end
