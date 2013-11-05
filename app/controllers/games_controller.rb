class GamesController < ApplicationController
  respond_to :html, :js
  def arrange_ships
      @player = Player.find(params[:player_id])
    end

<<<<<<< HEAD
    def play
      @player = Player.find(params[:player_id])
    end

    def refresh
      #@my_turn = Player.find(params[:player_id]).turn
      @my_turn = Player.find(1).turn
=======
  def play
    @player = Player.find(params[:player_id])

    # Create the two grids
    @battlefield_grid = @player.get_battlefield_grid
    @my_ships_grid = @player.get_my_ships_grid
  end

  def refresh
    @current_player = Player.find(params[:player_id])
    @my_turn = @current_player.turn
>>>>>>> 7b5695a8034c100141eeb633326a50a27bb19ddd

      @player_in_turn = PlayersController.find_player_with_token(Player.all)

<<<<<<< HEAD
      #@battlefield_cell = Cell.first #Last updated cell
      #@my_ships_cell = Cell.first #Last updated cell

      respond_to do |format|
        format.json { render :json => {
            turn: @my_turn,
            player_in_turn: @player_in_turn

          }
=======
    @battlefield_cell = @current_player.get_battlefield_grid.cells.select("x, y, state").order("updated_at DESC").first #Last updated cell
    @my_ships_cell = @current_player.get_my_ships_grid.cells.select("x, y, state").order("updated_at DESC").first #Last updated cell

    respond_to do |format|
      format.json { render :json => {
          turn: @my_turn,
          player_in_turn: @player_in_turn,
          battlefield_cell: @battlefield_cell,
          my_ships_cell: @my_ships_cell
>>>>>>> 7b5695a8034c100141eeb633326a50a27bb19ddd
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

<<<<<<< HEAD
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
        
        end

    end
=======
  def calculate_hits_and_misses
    x = Integer(params[:x])
    y = Integer(params[:y])
    player_id = Integer(params[:player_id])
    
>>>>>>> 7b5695a8034c100141eeb633326a50a27bb19ddd


<<<<<<< HEAD

=======
end
>>>>>>> 7b5695a8034c100141eeb633326a50a27bb19ddd
