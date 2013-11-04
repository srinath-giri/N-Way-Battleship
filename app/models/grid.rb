class Grid < ActiveRecord::Base
  attr_accessible :player_id, :grid_type

  belongs_to :player
  has_many :cells    
  
end
