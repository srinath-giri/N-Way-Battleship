class GamesController < ApplicationController

  def arrange_ships
    @player = Player.find(params[:player_id])
  end

  def play
    @player = Player.find(params[:player_id])

    # Create the two grids
    @battlefield_grid = @player.get_battlefield_grid
    @my_ships_grid = @player.get_my_ships_grid
  end

  def refresh
    @current_player = Player.find(params[:player_id])
    @my_turn = @current_player.turn

    @player_in_turn = PlayersController.find_player_with_token(Player.all)

    @battlefield_cell = @current_player.get_battlefield_grid.cells.select("x, y, state").order("updated_at DESC").first #Last updated cell
    @my_ships_cell = @current_player.get_my_ships_grid.cells.select("x, y, state").order("updated_at DESC").first #Last updated cell

    respond_to do |format|
      format.json { render :json => {
          turn: @my_turn,
          player_in_turn: @player_in_turn,
          battlefield_cell: @battlefield_cell,
          my_ships_cell: @my_ships_cell
        }
      }

    end
  end

  def take_turn
    @player = Player.find(params[:player_id])
    error = false
    x = Integer(params[:x])
    y = Integer(params[:y])

    if(x.between?(1, 10) && y.between?(1, 10) && @player.turn)
      PlayersController.pass_turn(Player.all)
    else
      error = true
    end

    calculate_hits_and_misses

    respond_to do |format|
      format.json { render :json => { turn: Player.find(params[:player_id]).turn, error: error} }
    end

  end

  def calculate_hits_and_misses
    x = Integer(params[:x])
    y = Integer(params[:y])
    player_id = Integer(params[:player_id])
    

  end

end
