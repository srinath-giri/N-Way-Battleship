class GamesController < ApplicationController

  def arrange_ships
    @player = Player.find(params[:player_id])
  end

  def play
    @player = Player.find(params[:player_id])
  end

  def refresh
    @my_turn = Player.find(params[:player_id]).turn

    @player_in_turn = PlayersController.find_player_with_token(Player.all)


    respond_to do |format|
      format.json { render :json => { turn: @my_turn, player_in_turn: @player_in_turn } }

    end
  end

  def take_turn
    @player = Player.find(params[:player_id])
    @grid = Grid.find(params[:player_id])
    error = false
    x = Integer(params[:x])
    y = Integer(params[:y])

    if(x.between?(1,@grid.columns) && y.between?(1,@grid.rows) && @player.turn)
      PlayersController.pass_turn(Player.all)
    else
      error = true
    end

    calculate_hits

    respond_to do |format|
      format.json { render :json => { turn: Player.find(params[:player_id]).turn, error: error} }
    end

  end

  def calculate_hits
    x = Integer(params[:x])
    y = Integer(params[:y])
    player_id = Integer(params[:player_id])
    #ship_on_slot = Ship.where("x_start <= ? AND y_start <= ? AND x_end >= ? AND y_end >= ? AND player_id == ?", x, y, x, y, player_id)
    #ship_on_slot.each do |ship|
    #  Integer slot_number = x - ship.x_start + y - ship.y_start
    #    if ship.state == nil
    #      hash = Hash.new
    #      hash[slot_number] = player_id
    #      ship.state = hash
    #      ship.save
    #    elsif ship.state[slot_number] == nil
    #      ship.state[slot_number] = player_id
    #      ship.save
    #    end
    #end
    
    Ship.all.each do |ship|
      if x >= ship.x_start && x <= ship.x_end && y >= ship.y_start && y <= ship.y_end && player_id != ship.player.id
        Integer slot_number = x - ship.x_start + y -ship.y_start
        if ship.state == nil
          hash = Hash.new
          hash[slot_number] = player_id
          ship.state = hash
          ship.save
        elsif ship.state[slot_number] == nil
          ship.state[slot_number] = player_id
          ship.save
        end
      end
    end

  end


end
