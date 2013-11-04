class GamesController < ApplicationController
helper_method :play
  def arrange_ships

  end

  def play
    

  end

#have variables for ship view and battleground, pass them into take a turn action


  def refresh
    @my_turn = Player.find(1).turn

    @player_in_turn = PlayersController.find_player_with_token(Player.all)


    respond_to do |format|
      format.json { render :json => { turn: @my_turn, player_in_turn: @player_in_turn } }

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
    head :ok 
  end


end
