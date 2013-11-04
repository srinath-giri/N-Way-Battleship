class Grid < ActiveRecord::Base
<<<<<<< HEAD
  belongs_to :player
  attr_accessible :columns, :player_id, :rows
  
=======
  attr_accessible :columns, :player_id, :rows, :grid_type

  belongs_to :player
  has_many :cells

>>>>>>> cell
  validates_presence_of(:columns)
  validates_numericality_of(:columns, :only_integer => true, :greater_than_or_equal_to => 1)
  validates_presence_of(:player_id)
  validates_numericality_of(:player_id, :only_integer => true, :greater_than_or_equal_to => 1)
  validates_presence_of(:rows)
  validates_numericality_of(:rows, :only_integer => true, :greater_than_or_equal_to => 1)
  
  
end
