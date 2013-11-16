class GamesController < ApplicationController
  respond_to :html, :js
  def arrange_ships
      @player = Player.find(params[:player_id])
      
      respond_to do |format|
        format.html { }
        format.json {   }
        
     end
      
    end

    

  def play
    @player = Player.find(params[:player_id])

    # Create the two grids
    @battlefield_grid = @player.get_battlefield_grid
    gon.battlefield_grid=@battlefield_grid.attributes
    gon.battlefield_cells=@battlefield_grid.cells.map &:attributes
    
    @my_ships_grid = @player.get_my_ships_grid
    gon.my_ships_grid=@my_ships_grid.attributes
    gon.my_ships_grid_cells=@my_ships_grid.cells.map &:attributes
  end

  def refresh
    @current_player = Player.find(params[:player_id])
    @my_turn = @current_player.turn

    @player_in_turn = PlayersController.find_player_with_token(Player.all)

    @battlefield_cell = @current_player.get_battlefield_grid.cells.select("x, y, state").order("updated_at DESC").first #Last updated cell
    @my_ships_cell = @current_player.get_my_ships_grid.cells.select("x, y, state").order("updated_at DESC").first #Last updated cell
    gon.battlefield_attack_cell=@battlefield_cell.attributes
    gon.my_ships_attack_cell=@my_ships_cell.attributes


    respond_to do |format|
      format.json { render :json => {
          turn: @my_turn,
          player_in_turn: @player_in_turn,
          battlefield_cell: gon.battlefield_attack_cell,
          my_ships_cell: gon.my_ships_attack_cell

        }
}
      end
    end

    def update
      @player = Player.find(params[:player_id])
      error = false
      x = Integer(params[:x])
      y = Integer(params[:y])

      if(x.between?(0, 9) && y.between?(0, 9) && @player.turn)
        PlayersController.pass_turn(Player.all)
        calculate_hits_and_misses
      else
        error = true
      end

      respond_to do |format|
        format.json { render :json => { turn: Player.find(params[:player_id]).turn, error: error} }
      end

    end

  def calculate_hits_and_misses
     
    x = Integer(params[:x])
    y = Integer(params[:y])
    player_id = Integer(params[:player_id])
    #create new move using x,y passed in play grid to test if attack coords are passed 
    #through grid
    @move=Move.new(x: x, y: y, player_id: player_id)
    if @move.save
      flash[:notice] = "Attack coords saved in move model"
              
    else
      flash[:notice] = "Attacks coords not saved in move model"
          
    end

    #calculation starts
    Player.where("id != ?", player_id).each do |opponent_player|
      player_cell = opponent_player.grids.where("grid_type = 'my_ships'")[0].cells.where("x = ? AND y = ?", x , y)
      if player_cell.empty? 
        #miss
        Grid.where("grid_type = 'battlefield'").each do |grid|
          if grid.player.id != opponent_player.id
            cell = grid.cells.where("x = ? AND y = ? ", x , y)[0]
            cell.state[opponent_player.id.to_s] = "m"
            cell.save
          end
        end
      else
        #has a ship there
        if player_cell[0].state["hit"] == false
          hitted_cell = player_cell[0]
          hitted_cell.state["hit"] = true
          hitted_cell.save
          Grid.where("grid_type = 'battlefield'").each do |grid|
            if grid.player.id != opponent_player.id
              cell = grid.cells.where("x = ? AND y = ? ", x , y)[0]
              cell.state[opponent_player.id.to_s] = "h"
              cell.save
            end
          end
        end
      end
    end
        
  end
end

    

