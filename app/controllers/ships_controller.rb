class ShipsController < ApplicationController
  def new
    @ship=Ship.new
  end
  
  def help
    
  end

  def create
    debugger
    #@ship=Ship.create(name: "Carrier", x_start: 0, x_end: 3, y_start: 0,y_end: 0, state: " ")
    @player=Player.find(1)
    @ship=@player.ships.build(params[:ship])
    if @ship.save
              flash[:notice] = "Ship added to grid."
             
            else
             flash[:notice] = "Ship not saved"
              

            render 'new'
            end
    
  end
  
  def ship_params
        params.require(:ship).permit(:name, :x_start, :y_start, :x_end, :y_end, :state)
      end
  
end
