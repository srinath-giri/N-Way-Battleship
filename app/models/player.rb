class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :turn, :email, :password, :password_confirmation, :remember_me, :status
  # possible status: out_of_game waiting arrange_ships in_game game_over

  has_many :grids
  belongs_to :game


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
