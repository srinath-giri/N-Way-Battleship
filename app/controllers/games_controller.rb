class GamesController < ApplicationController
  respond_to :html, :js
  def arrange_ships
      @player = Player.find(params[:player_id])
    end

    def play
      @player = Player.find(params[:player_id])
    end

    def refresh
      #@my_turn = Player.find(params[:player_id]).turn
      @my_turn = Player.find(1).turn

      @player_in_turn = PlayersController.find_player_with_token(Player.all)

      #@battlefield_cell = Cell.first #Last updated cell
      #@my_ships_cell = Cell.first #Last updated cell

      respond_to do |format|
        format.json { render :json => {
            turn: @my_turn,
            player_in_turn: @player_in_turn

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
        
        end

    end



