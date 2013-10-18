class Player < ActiveRecord::Base
  attr_accessible :name, :turn

  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :ships



  def assign_turn ()
    if @player.turn == false
      @player.turn == true
    else
      return
    end
  end
  def remove_turn ()
    if @player.turn == true
      @player.turn == false
    else
      return
    end
  end


  end
