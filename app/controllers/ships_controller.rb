class ShipsController < ApplicationController
  def new
    @ship=Ship.new
  end
  
  def help
    
  end

  def create
    
    @ship=Ship.create(name: "Carrier", x_start: 0, x_end: 3, y_start: 0,y_end: 0, state: " ")
    if @ship.save
              flash[:notice] = "Ship added to grid."
              #redirect_to @grid
              render '/grids/index'
            else
             flash[:notice] = "Ship not saved"
              #flash[:notice] = @item.customer_id

            render 'new'
            end
    
  end
  
  def ship_params
        params.require(:ship).permit(:name, :x_start, :y_start, :x_end, :y_end)
      end
  
end
