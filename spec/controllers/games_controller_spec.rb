require 'spec_helper'

# The documentation used as reference for writing these tests can be found in: https://www.relishapp.com/rspec/rspec-rails/v/2-1/docs/controller-specs/render-views

describe GamesController do

  render_views
  # Why we render the views explanation:   http://stackoverflow.com/questions/9027518/what-does-render-views-do-in-rspec
  # "it renders the view's in the controller spec. If you don't put render_views, the views won't render,
  # that means the controller is called but after it returns the views are not rendered.
  # Controller tests will run faster, as they won't have to render the view, but you might miss bugs in the view."



  context "Tests with one player" do

    before(:each) do
      @player = FactoryGirl.create(:player)

      # Necessary because of Devise (the calculate hits and misses requires login)
      @request.env["devise.mapping"] = Devise.mappings[:player]
      sign_in @player
    end


    context "arrange ships" do

      it "renders the arrange_ships template" do
        get :arrange_ships, player_id: @player.id
        response.should contain(/[Aa]rrange/)
      end
    end

    context "play" do
      it "renders the play template" do
        get :play, player_id: @player.id
        response.should render_template("play")
      end
    end

    context '#refresh' do
      it 'returns the state variable: player_in_turn' do
        @player.update_attributes(turn: true)
        get :refresh, player_id: @player.id, format: :json
        JSON.parse(response.body)['player_in_turn']['turn'].should be_true
        JSON.parse(response.body)['player_in_turn']['name'].should == @player.name
      end

      it 'returns the state variable: turn as true if the player has the turn' do
        @player.update_attributes(turn: true)
        get :refresh, player_id: @player.id, format: :json
        JSON.parse(response.body)['turn'].should be_true
      end

      it 'returns the state variable: turn as false if the player does not have the turn' do
        @player.update_attributes(turn: false)
        get :refresh, player_id: @player.id, format: :json
        JSON.parse(response.body)['turn'].should be_false
      end

      it 'returns the state variable: battlefield_cell' do
        @battlefield_grid = @player.get_battlefield_grid
        get :refresh, player_id: @player.id, format: :json
        JSON.parse(response.body)['battlefield_cell']['x'].should equal 9 # coordinate of last added cell
        JSON.parse(response.body)['battlefield_cell']['y'].should equal 9 # coordinate of last added cell
      end

      it 'returns the state variable: battlefield_cell' do
        @my_ships_grid = @player.get_my_ships_grid
        get :refresh, player_id: @player.id, format: :json
        JSON.parse(response.body)['my_ships_cell']['state']['orientation'].should_not be_nil
        JSON.parse(response.body)['my_ships_cell']['state']['orientation'].should_not == ''
      end


    end
  end



  context 'calculation for hits and misses' do
    before do

      @player1 = FactoryGirl.create(:player1, turn: true)
      @player2 = FactoryGirl.create(:player2, turn: false)
      @player3 = FactoryGirl.create(:player3, turn: false )

      # Necessary because of Devise (the calculate hits and misses requires login)
      @request.env["devise.mapping"] = Devise.mappings[:player]
      sign_in @player1
      sign_in @player2
      sign_in @player3

      @grid_p1_bf = @player1.grids.create(grid_type: "battlefield" )
      @grid_p1_ms = @player1.grids.create(grid_type: "my_ships")
      @grid_p2_bf = @player2.grids.create(grid_type: "battlefield")
      @grid_p2_ms = @player2.grids.create(grid_type: "my_ships")
      @grid_p3_bf = @player3.grids.create(grid_type: "battlefield")
      @grid_p3_ms = @player3.grids.create(grid_type: "my_ships")

      @grid_p1_bf.cells.create(x: 0 , y: 0, state: {"2"=>"u","3"=>"u"})
      @grid_p1_bf.cells.create(x: 0 , y: 1, state: {"2"=>"u","3"=>"u"})
      @grid_p1_bf.cells.create(x: 1 , y: 0, state: {"2"=>"u","3"=>"u"})
      @grid_p1_bf.cells.create(x: 1 , y: 1, state: {"2"=>"u","3"=>"u"})

      @grid_p2_bf.cells.create(x: 0 , y: 0, state: {"1"=>"u","3"=>"u"})
      @grid_p2_bf.cells.create(x: 0 , y: 1, state: {"1"=>"u","3"=>"u"})
      @grid_p2_bf.cells.create(x: 1 , y: 0, state: {"1"=>"u","3"=>"u"})
      @grid_p2_bf.cells.create(x: 1 , y: 1, state: {"1"=>"u","3"=>"u"})

      @grid_p3_bf.cells.create(x: 0 , y: 0, state: {"1"=>"u","2"=>"u"})
      @grid_p3_bf.cells.create(x: 0 , y: 1, state: {"1"=>"u","2"=>"u"})
      @grid_p3_bf.cells.create(x: 1 , y: 0, state: {"1"=>"u","2"=>"u"})
      @grid_p3_bf.cells.create(x: 1 , y: 1, state: {"1"=>"u","2"=>"u"})

      @grid_p1_ms.cells.create(x: 0 , y: 0, state: {"orientation"=>"v","block"=>1,"type"=>"p","hit"=>false})
      @grid_p1_ms.cells.create(x: 1 , y: 0, state: {"orientation"=>"v","block"=>1,"type"=>"p","hit"=>false})

      @grid_p2_ms.cells.create(x: 0 , y: 0, state: {"orientation"=>"h","block"=>1,"type"=>"p","hit"=>false})
      @grid_p2_ms.cells.create(x: 0 , y: 1, state: {"orientation"=>"h","block"=>1,"type"=>"p","hit"=>false})      
    end

    after do
      @player1.destroy
      @player2.destroy
      @player3.destroy

      @grid_p1_bf.destroy
      @grid_p1_ms.destroy
      @grid_p2_bf.destroy
      @grid_p2_ms.destroy
      @grid_p3_bf.destroy
      @grid_p3_ms.destroy
    end

    it 'can change others ship cell status if the attack is successful on an oponent' do
      xhr :post, :update, player_id: @player1.id, x: 0, y: 0
      @grid_p2_ms.cells.where("x = 0 AND y = 0")[0].state["hit"].should == true    
    end

    it 'does not change own ship cell status' do
      xhr :post, :update, player_id: @player1.id, x: 0, y: 0
      @grid_p1_ms.cells.where("x = 0 AND y = 0")[0].state["hit"].should == false    
    end

    it 'does not change any ship cell status when nothing was hit' do
      xhr :post, :update, player_id: @player1.id, x: 1, y: 1
      @grid_p1_ms.cells.where("x = 0 AND y = 0")[0].state["hit"].should == false
      @grid_p1_ms.cells.where("x = 1 AND y = 0")[0].state["hit"].should == false
      @grid_p2_ms.cells.where("x = 0 AND y = 0")[0].state["hit"].should == false
      @grid_p2_ms.cells.where("x = 0 AND y = 1")[0].state["hit"].should == false
    end

    it 'changes every players battlefield cell for a certain hit' do
      xhr :post, :update, player_id: @player1.id, x: 0, y: 0
      @grid_p1_bf.cells.where("x = 0 AND y = 0")[0].state.should == {"2" => "h", "3" => "m"}
      @grid_p2_bf.cells.where("x = 0 AND y = 0")[0].state.should == {"1" => "u", "3" => "m"}
      @grid_p3_bf.cells.where("x = 0 AND y = 0")[0].state.should == {"1" => "u", "2" => "h"}
    end

    it 'changes every players battlefield cell for a certain miss' do
      xhr :post, :update, player_id: @player1.id, x: 1, y: 1
      @grid_p1_bf.cells.where("x = 1 AND y = 1")[0].state.should == {"2" => "m", "3" => "m"}
      @grid_p2_bf.cells.where("x = 1 AND y = 1")[0].state.should == {"1" => "u", "3" => "m"}
      @grid_p3_bf.cells.where("x = 1 AND y = 1")[0].state.should == {"1" => "u", "2" => "m"}
    end

  end

  context 'Store ships arrangement' do
    before do
      @player1 = FactoryGirl.create(:player1, turn: true)
      @request.env["devise.mapping"] = Devise.mappings[:player]
      sign_in @player1
    end

    it 'stores 17 ship cells for a player' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"v", xb:"2", yb:"2", ob:"v", xc:"3", yc:"3", oc:"v", xs:"4", ys:"4", os:"v", xp:"5" ,yp:"5", op:"v"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.count.should == 17
    end

    it 'correctly stores vertical carrier cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"v", xb:"2", yb:"2", ob:"v", xc:"3", yc:"3", oc:"v", xs:"4", ys:"4", os:"v", xp:"5" ,yp:"5", op:"v"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 3 AND y = 3")[0].state.should == {"orientation" => "v", "block" => 1, "type" => "c", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 3 AND y = 4")[0].state.should == {"orientation" => "v", "block" => 2, "type" => "c", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 3 AND y = 5")[0].state.should == {"orientation" => "v", "block" => 3, "type" => "c", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 3 AND y = 6")[0].state.should == {"orientation" => "v", "block" => 4, "type" => "c", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 3 AND y = 7")[0].state.should == {"orientation" => "v", "block" => 5, "type" => "c", "hit" => false}
    end

    it 'correctly stores horizontal carrier cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"h", xb:"2", yb:"2", ob:"h", xc:"3", yc:"3", oc:"h", xs:"4", ys:"4", os:"h", xp:"5" ,yp:"5", op:"h"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 3 AND y = 3")[0].state.should == {"orientation" => "h", "block" => 1, "type" => "c", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 4 AND y = 3")[0].state.should == {"orientation" => "h", "block" => 2, "type" => "c", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 5 AND y = 3")[0].state.should == {"orientation" => "h", "block" => 3, "type" => "c", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 6 AND y = 3")[0].state.should == {"orientation" => "h", "block" => 4, "type" => "c", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 7 AND y = 3")[0].state.should == {"orientation" => "h", "block" => 5, "type" => "c", "hit" => false}
    end

    it 'correctly stores vertical battleship cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"v", xb:"2", yb:"2", ob:"v", xc:"3", yc:"3", oc:"v", xs:"4", ys:"4", os:"v", xp:"5" ,yp:"5", op:"v"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 2 AND y = 2")[0].state.should == {"orientation" => "v", "block" => 1, "type" => "b", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 2 AND y = 3")[0].state.should == {"orientation" => "v", "block" => 2, "type" => "b", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 2 AND y = 4")[0].state.should == {"orientation" => "v", "block" => 3, "type" => "b", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 2 AND y = 5")[0].state.should == {"orientation" => "v", "block" => 4, "type" => "b", "hit" => false}
    end

    it 'correctly stores horizontal battleship cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"h", xb:"2", yb:"2", ob:"h", xc:"3", yc:"3", oc:"h", xs:"4", ys:"4", os:"h", xp:"5" ,yp:"5", op:"h"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 2 AND y = 2")[0].state.should == {"orientation" => "h", "block" => 1, "type" => "b", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 3 AND y = 2")[0].state.should == {"orientation" => "h", "block" => 2, "type" => "b", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 4 AND y = 2")[0].state.should == {"orientation" => "h", "block" => 3, "type" => "b", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 5 AND y = 2")[0].state.should == {"orientation" => "h", "block" => 4, "type" => "b", "hit" => false}
    end

    it 'correctly stores vertical destroyer cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"v", xb:"2", yb:"2", ob:"v", xc:"3", yc:"3", oc:"v", xs:"4", ys:"4", os:"v", xp:"5" ,yp:"5", op:"v"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 1 AND y = 1")[0].state.should == {"orientation" => "v", "block" => 1, "type" => "d", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 1 AND y = 2")[0].state.should == {"orientation" => "v", "block" => 2, "type" => "d", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 1 AND y = 3")[0].state.should == {"orientation" => "v", "block" => 3, "type" => "d", "hit" => false}
    end

    it 'correctly stores horizontal destroyer cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"h", xb:"2", yb:"2", ob:"h", xc:"3", yc:"3", oc:"h", xs:"4", ys:"4", os:"h", xp:"5" ,yp:"5", op:"h"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 1 AND y = 1")[0].state.should == {"orientation" => "h", "block" => 1, "type" => "d", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 2 AND y = 1")[0].state.should == {"orientation" => "h", "block" => 2, "type" => "d", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 3 AND y = 1")[0].state.should == {"orientation" => "h", "block" => 3, "type" => "d", "hit" => false}
    end

    it 'correctly stores vertical submarine cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"v", xb:"2", yb:"2", ob:"v", xc:"3", yc:"3", oc:"v", xs:"4", ys:"4", os:"v", xp:"5" ,yp:"5", op:"v"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 4 AND y = 4")[0].state.should == {"orientation" => "v", "block" => 1, "type" => "s", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 4 AND y = 5")[0].state.should == {"orientation" => "v", "block" => 2, "type" => "s", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 4 AND y = 6")[0].state.should == {"orientation" => "v", "block" => 3, "type" => "s", "hit" => false}
    end

    it 'correctly stores horizontal submarine cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"h", xb:"2", yb:"2", ob:"h", xc:"3", yc:"3", oc:"h", xs:"4", ys:"4", os:"h", xp:"5" ,yp:"5", op:"h"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 4 AND y = 4")[0].state.should == {"orientation" => "h", "block" => 1, "type" => "s", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 5 AND y = 4")[0].state.should == {"orientation" => "h", "block" => 2, "type" => "s", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 6 AND y = 4")[0].state.should == {"orientation" => "h", "block" => 3, "type" => "s", "hit" => false}
    end

    it 'correctly stores vertical patrol boat cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"v", xb:"2", yb:"2", ob:"v", xc:"3", yc:"3", oc:"v", xs:"4", ys:"4", os:"v", xp:"5" ,yp:"5", op:"v"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 5 AND y = 5")[0].state.should == {"orientation" => "v", "block" => 1, "type" => "p", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 5 AND y = 6")[0].state.should == {"orientation" => "v", "block" => 2, "type" => "p", "hit" => false}
    end

    it 'correctly stores horizontal patrol boat cells' do
      xhr :post, :save_ships, player_id: @player1.id, xd:"1", yd:"1", od:"h", xb:"2", yb:"2", ob:"h", xc:"3", yc:"3", oc:"h", xs:"4", ys:"4", os:"h", xp:"5" ,yp:"5", op:"h"
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 5 AND y = 5")[0].state.should == {"orientation" => "h", "block" => 1, "type" => "p", "hit" => false}
      Grid.where("player_id = ? AND grid_type = 'my_ships'", @player1.id)[0].cells.where("x = 6 AND y = 5")[0].state.should == {"orientation" => "h", "block" => 2, "type" => "p", "hit" => false}
    end

  end
  

end


