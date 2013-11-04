class Player < ActiveRecord::Base
  has_many :grids
  attr_accessible :name, :turn

  has_many :grids

  validates :name, presence: true
  validates :name, uniqueness: true



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
