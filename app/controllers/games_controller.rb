class GamesController < ApplicationController

  def arrange_ships

  end

  def play

  end

  def my_turn
    @my_turn = Player.find(params[:player_id]).turn

    turn_x = params[:x]
    turn_y = params[:y]

    @status = true
    respond_to do |format|
      format.json { render :json => @my_turn }

    end
  end

end
