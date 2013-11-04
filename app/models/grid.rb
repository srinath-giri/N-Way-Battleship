class Grid < ActiveRecord::Base
  attr_accessible :player_id, :grid_type

  belongs_to :player
  has_many :cells

  validates_inclusion_of :grid_type, :in => %w( battlefield my_ships )

end
