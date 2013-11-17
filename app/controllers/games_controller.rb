class GamesController < ApplicationController
  respond_to :html, :js
  def arrange_ships
      @player = Player.find(params[:player_id])
      
      respond_to do |format|
        format.html { }
        format.json {   }
        
     end
      
    end

    
  def save_ships
    @player = Player.find(params[:player_id])
    
    # create cell object from POST parameters
    # @cell=Cell.Create...
    # Delete the cells and the my_ship grid if there are data in the database
    if Grid.where("player_id = ? AND grid_type = 'my_ships'", @player.id).empty? == false 
      grid = Grid.where("player_id = ? AND grid_type = 'my_ships'", @player.id).first
      grid.cells.destroy_all
      grid.destroy
    end  

    @player_input_data = params
    @my_ships_grid = @player.grids.create(grid_type: "my_ships")
    
    #create cells for carrier size = 5
    if @player_input_data["oc"] == "h"
      for i in 0..4
        state = Hash.new
        state = { "orientation" => "h", "block" => i+1, "type" => "c", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xc"].to_i + i, y: @player_input_data["yc"].to_i, state: state )
      end
    elsif @player_input_data["oc"] == "v"
      for i in 0..4
        state = Hash.new
        state = { "orientation" => "v", "block" => i+1, "type" => "c", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xc"].to_i, y: @player_input_data["yc"].to_i + i , state: state )
      end
    end

    #create cells for battleship size = 4
    if @player_input_data["ob"] == "h"
      for i in 0..3
        state = Hash.new
        state = { "orientation" => "h", "block" => i+1, "type" => "b", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xb"].to_i + i, y: @player_input_data["yb"].to_i, state: state )
      end
    elsif @player_input_data["ob"] == "v"
      for i in 0..3
        state = Hash.new
        state = { "orientation" => "v", "block" => i+1, "type" => "b", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xb"].to_i, y: @player_input_data["yb"].to_i + i , state: state )
      end
    end

    #create cells for destroyer size = 3
    if @player_input_data["od"] == "h"
      for i in 0..2
        state = Hash.new
        state = { "orientation" => "h", "block" => i+1, "type" => "d", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xd"].to_i + i, y: @player_input_data["yd"].to_i, state: state )
      end
    elsif @player_input_data["od"] == "v"
      for i in 0..2
        state = Hash.new
        state = { "orientation" => "v", "block" => i+1, "type" => "d", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xd"].to_i, y: @player_input_data["yd"].to_i + i , state: state )
      end
    end

    #create cells for submarine size = 3
    if @player_input_data["os"] == "h"
      for i in 0..2
        state = Hash.new
        state = { "orientation" => "h", "block" => i+1, "type" => "s", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xs"].to_i + i, y: @player_input_data["ys"].to_i, state: state )
      end
    elsif @player_input_data["os"] == "v"
      for i in 0..2
        state = Hash.new
        state = { "orientation" => "v", "block" => i+1, "type" => "s", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xs"].to_i, y: @player_input_data["ys"].to_i + i , state: state )
      end
    end

    #create cells for patrolboat size = 2
    if @player_input_data["op"] == "h"
      for i in 0..1
        state = Hash.new
        state = { "orientation" => "h", "block" => i+1, "type" => "p", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xp"].to_i + i, y: @player_input_data["yp"].to_i, state: state )
      end
    elsif @player_input_data["op"] == "v"
      for i in 0..1
        state = Hash.new
        state = { "orientation" => "v", "block" => i+1, "type" => "p", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xp"].to_i, y: @player_input_data["yp"].to_i + i , state: state )
      end
    end



     respond_to do |format|
#       if @cell.save
         format.html { redirect_to play_path(player_id:@player.id), status: 302 }
        format.json {  }
#       else
#         format.html { render 'arrange_ships' }   
#         format.json { render json: @cell.errors, status: :unprocessable_entity }
#       end
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

    

