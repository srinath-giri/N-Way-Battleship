class Ship < ActiveRecord::Base
  attr_accessible :name, :state, :x_end, :x_start, :y_end, :y_start
  validates_presence_of(:name)
  validates_inclusion_of :name, :in => %w( Destroyer Battleship Carrier Submarine 'Patrol Boat')
  validates_presence_of(:x_start)
  validates_numericality_of(:x_start, :only_integer => true, :greater_than_or_equal_to => 1)
  validates_presence_of(:x_end)
  validates_numericality_of(:x_end, :only_integer => true, :greater_than_or_equal_to => 1)
  validates_presence_of(:y_start)
  validates_numericality_of(:y_start, :only_integer => true, :greater_than_or_equal_to => 1)
  validates_presence_of(:y_end)
  validates_numericality_of(:y_end, :only_integer => true, :greater_than_or_equal_to => 1)

  before_save :validate_grid_point!

  class InvalidGridPoint < ArgumentError
  end

  def validate_grid_point!
    if (x_start > x_end)
      raise InvalidGridPoint, "Start Grid Position should be left of End Grid Position"
    end
    if (y_start > y_end)
      raise InvalidGridPoint, "Start Grid Position should be top of End Grid Position"
    end
  end

end
