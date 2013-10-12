class PlayersController < ApplicationController

  def self.pass_turn(players)

    current_player = find_player_with_token(players)
    next_player = determine_next_player(players, current_player)

    if current_player # if it's not nil
      current_player.turn = false
    end

    next_player.turn = true

  end

  def self.find_player_with_token(players)
    players.each do |player|
      if player.turn
        return player
      end
    end
    nil # if no player has the token
  end

  def self.determine_next_player(players, current_player)

    # we determine the next player based on the player id
    players.sort_by! { |player| player[:id] }

    if current_player

    else
      players[0]  # return first player if none has the token
    end
  end

end
