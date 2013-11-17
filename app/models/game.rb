class Game < ActiveRecord::Base
  attr_accessible :number_of_players, :game_status

  has_many :players

  validates :number_of_players, numericality: { only_integer: true },
            inclusion: { in: (2..10), message: "should be between 2 and 10" }
  validates_inclusion_of :game_status, :in => %w( waiting in_game game_over )

end
