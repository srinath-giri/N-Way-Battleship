class GamesController < ApplicationController
helper_method :play
  def arrange_ships
    @player = Player.find(params[:player_id])
  end

  def play
<<<<<<< HEAD
    

=======
    @player = Player.find(params[:player_id])
>>>>>>> 03623cdc6b45310ab5deb5b19f630d71e38ce2b4
  end

#have variables for ship view and battleground, pass them into take a turn action


  def refresh
    @my_turn = Player.find(1).turn

    @player_in_turn = PlayersController.find_player_with_token(Player.all)

    #@battlefield_cell = Cell.first #Last updated cell
    #@my_ships_cell = Cell.first #Last updated cell

    respond_to do |format|
      format.json { render :json => {
          turn: @my_turn,
          player_in_turn: @player_in_turn

          #battlefield_cell: @battlefield_cell,
          #my_ships_cell: @my_ships_cell
        }
      }

    end
  end

<<<<<<< HEAD
  def calculate_hits
    
     x = Integer(params[:x])
    y = Integer(params[:y])
    player_id = Integer(params[:player_id])
  
    
    #ship_on_slot = Ship.where("x_start <= ? AND y_start <= ? AND x_end >= ? AND y_end >= ? AND player_id == ?", x, y, x, y, player_id)
=======
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
    miss_record = Hash.new
    Player.all.each do |player|
      miss_record[player.id] = true
    end
    miss_record[player_id] = false
    #ship_on_slot = Ship.where("x_start <= ? AND y_start <= ? AND x_end >= ? AND y_end >= ? AND player_id = ?", x, y, x, y, player_id)
>>>>>>> 03623cdc6b45310ab5deb5b19f630d71e38ce2b4
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
        miss_record[ship.player.id] = false
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

    miss_record.each do |id,miss|
      if miss == true
        if Miss.where("player_id = ? AND x = ? AND y = ?",id,x,y).empty? == true
          Miss.create(player_id: id,x: x,y: y)
        end
      end
    end

  end


end
