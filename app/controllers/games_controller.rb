class GamesController < ApplicationController

  respond_to :html, :js

  before_filter :authenticate_player!, :except  => :index

  def index
     @existing_games = Game.where("game_status = ?", "waiting")
  end

  def new
    player = current_player
    @game = player.build_game(params[:new_game])
    @game.game_status = "waiting"
    @game.creator = player.name

    respond_to do |format|
      if @game.save
        player.game_id = @game.id
        player.turn = false
        player.save
        format.html { redirect_to waiting_path, notice: 'The game was successfully created.' }
      else
        format.html { redirect_to root_path, notice: @game.errors.full_messages.to_sentence }
      end
    end

  end

  def waiting
    @number_of_players = current_player.game.number_of_players
    @player = current_player

    @player.status = "waiting"
    @player.save
  end

  def join_game
    current_player.game_id = params[:game_id]
    current_player.turn = false
    respond_to do |format|
      if current_player.save
        format.html { redirect_to waiting_path, notice: 'You have successfully joined the game.' }
      else
        format.html { redirect_to root_path, notice: current_player.errors.full_messages.to_sentence }
      end
    end
  end

  def arrange_ships
      @player = Player.find(params[:player_id])

      @player.game.update_attributes(game_status: "arrange_ships")
      @player.status = "arrange_ships"
      @player.save

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
        state = { "orientation" => "h", "block" => (i+1).to_s, "type" => "c", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xc"].to_i + i, y: @player_input_data["yc"].to_i, state: state )
      end
    elsif @player_input_data["oc"] == "v"
      for i in 0..4
        state = Hash.new
        state = { "orientation" => "v", "block" => (i+1).to_s, "type" => "c", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xc"].to_i, y: @player_input_data["yc"].to_i + i , state: state )
      end
    end

    #create cells for battleship size = 4
    if @player_input_data["ob"] == "h"
      for i in 0..3
        state = Hash.new
        state = { "orientation" => "h", "block" => (i+1).to_s, "type" => "b", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xb"].to_i + i, y: @player_input_data["yb"].to_i, state: state )
      end
    elsif @player_input_data["ob"] == "v"
      for i in 0..3
        state = Hash.new
        state = { "orientation" => "v", "block" => (i+1).to_s, "type" => "b", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xb"].to_i, y: @player_input_data["yb"].to_i + i , state: state )
      end
    end

    #create cells for destroyer size = 3
    if @player_input_data["od"] == "h"
      for i in 0..2
        state = Hash.new
        state = { "orientation" => "h", "block" => (i+1).to_s, "type" => "d", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xd"].to_i + i, y: @player_input_data["yd"].to_i, state: state )
      end
    elsif @player_input_data["od"] == "v"
      for i in 0..2
        state = Hash.new
        state = { "orientation" => "v", "block" => (i+1).to_s, "type" => "d", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xd"].to_i, y: @player_input_data["yd"].to_i + i , state: state )
      end
    end

    #create cells for submarine size = 3
    if @player_input_data["os"] == "h"
      for i in 0..2
        state = Hash.new
        state = { "orientation" => "h", "block" => (i+1).to_s, "type" => "s", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xs"].to_i + i, y: @player_input_data["ys"].to_i, state: state )
      end
    elsif @player_input_data["os"] == "v"
      for i in 0..2
        state = Hash.new
        state = { "orientation" => "v", "block" => (i+1).to_s, "type" => "s", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xs"].to_i, y: @player_input_data["ys"].to_i + i , state: state )
      end
    end

    #create cells for patrolboat size = 2
    if @player_input_data["op"] == "h"
      for i in 0..1
        state = Hash.new
        state = { "orientation" => "h", "block" => (i+1).to_s, "type" => "p", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xp"].to_i + i, y: @player_input_data["yp"].to_i, state: state )
      end
    elsif @player_input_data["op"] == "v"
      for i in 0..1
        state = Hash.new
        state = { "orientation" => "v", "block" => (i+1).to_s, "type" => "p", "hit" => false }
        @my_ships_grid.cells.create(x: @player_input_data["xp"].to_i, y: @player_input_data["yp"].to_i + i , state: state )
      end
    end





    respond_to do |format|

      format.js {render :js => "window.location.href = ('#{play_path(@player.id)}');"}

    end
    
  end  
    

  def play
    @player = Player.find(params[:player_id])

    # update the player status
    @player.status = "in_game"
    @player.save

    #update the game status
    @players = @player.game.players
    players_in_game = 0

    @players.each do |player|
      if player.status == "in_game"
        players_in_game += 1
      end
    end

    if players_in_game == @players.size
      @player.game.update_attributes(game_status: "in_game")
      # Pass the turn to assign the turn to the first player
      PlayersController.pass_turn(@players)
    end

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

    players = Player.where("game_id = ?", @current_player.game_id)
    @player_in_turn = PlayersController.find_player_with_token(players)

    @battlefield_cell = @current_player.get_battlefield_grid.cells.select("x, y, state").order("updated_at DESC").first #Last updated cell
    @my_ships_cell = @current_player.get_my_ships_grid.cells.select("x, y, state").order("updated_at DESC").first #Last updated cell
    gon.battlefield_attack_cell = @battlefield_cell.attributes
    gon.my_ships_attack_cell = @my_ships_cell.attributes


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

      if x.between?(0, 9) && y.between?(0, 9) && @player.turn
        calculate_hits_and_misses
        players = Player.where("game_id = ? AND status = ?", @player.game_id, "in_game")
        PlayersController.pass_turn(players)
      else
        error = true
      end

      respond_to do |format|
        format.json { render :json => { error: error} }
      end

    end

  def calculate_hits_and_misses
     
    x = Integer(params[:x])
    y = Integer(params[:y])
    player_id = Integer(params[:player_id])
    game_id = Player.find(player_id).game_id
    #create new move using x,y passed in play grid to test if attack coords are passed 
    #through grid
    @move=Move.new(x: x, y: y, player_id: player_id)
    if @move.save
      flash[:notice] = "Attack coords saved in move model"
              
    else
      flash[:notice] = "Attacks coords not saved in move model"
          
    end

    #calculation starts
    Player.where("id != ? AND game_id = ?", player_id, game_id).each do |opponent_player|
    #####Player.where("game_id = ?", game_id).each do |opponent_player|
      player_cell = opponent_player.grids.where("grid_type = 'my_ships'")[0].cells.where("x = ? AND y = ?", x , y)
      if player_cell.empty? 
        #miss
        Player.where("game_id = ?", game_id).each do |each_player|
          grid = each_player.grids.where("grid_type = 'battlefield'")[0]
          cell = grid.cells.where("x = ? AND y = ? ", x , y)[0]
          cell.state[opponent_player.id.to_s] = "m"
          cell.save
        end
      else
        #has a ship there
        if player_cell[0].state["hit"] == false
          hitted_cell = player_cell[0]
          hitted_cell.state["hit"] = true
          hitted_cell.save
          Player.where("game_id = ?", game_id).each do |each_player|
            grid = each_player.grids.where("grid_type = 'battlefield'")[0]
            cell = grid.cells.where("x = ? AND y = ? ", x , y)[0]
            cell.state[opponent_player.id.to_s] = "h"
            cell.save
          end

          #check if the player's all ships are sunk
          number_of_cells = 0
          number_of_hitted_cells = 0 
          opponent_player.grids.where("grid_type = 'my_ships'")[0].cells.each do |each_cell|
            number_of_cells = number_of_cells + 1
            if each_cell.state["hit"] == true 
              number_of_hitted_cells = number_of_hitted_cells + 1
            end                      
          end           
          if number_of_hitted_cells == number_of_cells
            opponent_player.status = "game_over"  
            opponent_player.save
          end

            
        end
      end
    end
        
  end

  def refresh_waiting_view
    game = Game.find(params[:game_id])
    @players_who_joined = game.players

    respond_to do |format|
      format.json { render :json => { players_who_joined: @players_who_joined } }
    end
  end

end

    
