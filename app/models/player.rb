class Player < ActiveRecord::Base
  has_many :grids
  attr_accessible :name, :turn

 

   validates :name, presence: true
   validates :name, uniqueness: true

  def get_battlefield_grid
    Grid.create_grid_for_player('battlefield', self)
  end

  def get_my_ships_grid
    Grid.create_grid_for_player('my_ships', self)
  end

  def assign_turn ()
    if @player.turn == false
      @player.turn == true
      # TODO: save
    else
      return
    end
  end
  def remove_turn ()
    if @player.turn == true
      @player.turn == false
      # TODO: save
    else
      return
    end
  end


  end
