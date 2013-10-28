class GamesController < ApplicationController

  def arrange_ships

  end

  def play

  end

  def refresh
    @my_turn = Player.find(params[:player_id]).turn
    @player_in_turn = PlayersController.find_player_with_token(Player.all)
    respond_to do |format|
      format.json { render :json => { turn: @my_turn, player_in_turn: @player_in_turn } }

    end
  end

end
