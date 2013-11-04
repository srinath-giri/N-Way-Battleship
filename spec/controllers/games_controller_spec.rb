require 'spec_helper'

# The documentation used as reference for writing these tests can be found in: https://www.relishapp.com/rspec/rspec-rails/v/2-1/docs/controller-specs/render-views

describe GamesController do

  render_views
  # Why we render the views explanation:   http://stackoverflow.com/questions/9027518/what-does-render-views-do-in-rspec
  # "it renders the view's in the controller spec. If you don't put render_views, the views won't render,
  # that means the controller is called but after it returns the views are not rendered.
  # Controller tests will run faster, as they won't have to render the view, but you might miss bugs in the view."

  context "arrange ships" do

    before do
      @player = FactoryGirl.create(:player, id:1, name:"Player1", turn:true)
    end

    it "renders the arrange_ships template" do
      get :arrange_ships, player_id: @player.id
      response.should contain(/[Aa]rrange/)
    end
  end

  context "play" do

    before do
      @player = FactoryGirl.create(:player, id:1, name:"Player1", turn:true)
    end

    it "renders the play template" do
      get :play, player_id: @player.id
      response.should render_template("play")
    end
  end

  context '#refresh' do

    before do
      @player = Player.create(name: 'test2', turn: true)
    end
    after do
      @player.destroy # with create in before, it is not in a transaction, meaning it is not rolled back - destroy explicitly to clean up.
    end

    it 'returns the state variable: player_in_turn' do
      @player.update_attributes(turn: true)
      get :refresh, player_id: @player.id, format: :json
      JSON.parse(response.body)['player_in_turn']['turn'].should be_true
      JSON.parse(response.body)['player_in_turn']['name'].should_not == ''
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

    it 'returns the state variable: battlefield' do
      @player.update_attributes(turn: true)
      get :refresh, player_id: @player.id, format: :json
      JSON.parse(response.body)['player_in_turn']['turn'].should be_true
      JSON.parse(response.body)['player_in_turn']['name'].should_not == ''
    end

  end

  context 'calculate_hits' do
    before do
      @player1 = Player.create(name: 'grace', turn: true)
      @player2 = Player.create(name: 'ibrahim', turn: false)
      @player3 = Player.create(name: 'owen', turn: false)
      @grid1 = FactoryGirl.create(:grid,player_id:@player1.id)
      @grid2 = FactoryGirl.create(:grid,player_id:@player2.id)
      @grid3 = FactoryGirl.create(:grid,player_id:@player3.id)
      @player1.ships.create(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
      @player2.ships.create(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
      @player3.ships.create(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
    end

    it 'can change ship hit status when the attack is within range' do
      xhr :post, :take_turn, player_id: @player1.id, x: 1, y: 2
      @player2.ships.first.state[1].should == @player1.id    
    end

    it 'does not change ship hit status when the attack is out of range' do
      xhr :post, :take_turn, player_id: @player1.id, x: 2, y: 2
      @player2.ships.first.state.should == nil
    end

    it 'does not change ships hit status of attacker' do
      xhr :post, :take_turn, player_id: @player1.id, x: 1, y: 2
      @player1.ships.first.state.should == nil
    end

    it 'does not change ships hit status if the slot of ship has already been hit' do
      xhr :post, :take_turn, player_id: @player1.id, x: 1, y: 2
      xhr :post, :take_turn, player_id: @player3.id, x: 1, y: 2
      @player2.ships.first.state[1].should == @player1.id
    end


    it 'can change status of multiple ships if player hit more than one ship' do
      xhr :post, :take_turn, player_id: @player1.id, x: 1, y: 2
      @player2.ships.first.state[1].should == @player1.id
      @player3.ships.first.state[1].should == @player1.id
    end

  end

  context 'calculate_misses' do
    before do
      @player1 = Player.create(name: 'grace', turn: true)
      @player2 = Player.create(name: 'ibrahim', turn: false)
      @player3 = Player.create(name: 'owen', turn: false)
      @grid1 = FactoryGirl.create(:grid,player_id:@player1.id)
      @grid2 = FactoryGirl.create(:grid,player_id:@player2.id)
      @grid3 = FactoryGirl.create(:grid,player_id:@player3.id)
      @player1.ships.create(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
      @player2.ships.create(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
      @player3.ships.create(name: "Destroyer", x_start: 2, x_end: 2, y_start: 1, y_end: 3, state: nil)
    end

    it 'can stores miss when the attack is outof range' do
      xhr :post, :take_turn, player_id: @player1.id, x: 2, y: 2
      Miss.first.player_id.should == @player2.id
      Miss.first.x.should == 2
      Miss.first.y.should == 2    
    end

    it 'does not store miss when the attack is in range' do
      xhr :post, :take_turn, player_id: @player1.id, x: 2, y: 2
      Miss.count.should == 1   
    end

    it 'does not store miss for the ship of attacker' do
      xhr :post, :take_turn, player_id: @player1.id, x: 2, y: 2
      Miss.count.should == 1  
    end

    it 'does not create duplicate miss records' do
      xhr :post, :take_turn, player_id: @player1.id, x: 2, y: 2
      xhr :post, :take_turn, player_id: @player3.id, x: 2, y: 2
      Miss.count.should == 2  
    end

  end


  context 'take turn' do

    before do
      @player1 = FactoryGirl.create(:player, id:1, name:"Player1", turn:true)
      @player2 = FactoryGirl.create(:player, id:2, name:"Player2", turn:false)
      @grid1 = FactoryGirl.create(:grid,player_id:1)
      @grid2 = FactoryGirl.create(:grid,player_id:2)
    end

    it 'is not allowed for a player when it is not his turn' do
      put :take_turn, player_id:@player2.id, x: @grid2.columns/2, y: @grid2.rows/2, format: :json
      JSON.parse(response.body)['error'].should be_true
      JSON.parse(response.body)['turn'].should be_false
    end

    it 'coordinates submitted outside battle grid are not accepted' do
      put :take_turn, player_id:@player1.id, x: @grid1.columns+100, y: @grid1.rows+100, format: :json
      JSON.parse(response.body)['error'].should be_true
      JSON.parse(response.body)['turn'].should be_true

      put :take_turn, player_id:@player1.id, x: -1, y: -1, format: :json
      JSON.parse(response.body)['error'].should be_true
      JSON.parse(response.body)['turn'].should be_true

    end

    it 'coordinates submitted inside battle grid are accepted' do
      put :take_turn, player_id:@player1.id, x: @grid1.columns/2, y: @grid1.rows/2, format: :json
      JSON.parse(response.body)['turn'].should be_false
    end

    it 'passes turn to next player after taking a proper shot' do
      put :take_turn, player_id:@player1.id, x: @grid1.columns/2, y: @grid1.rows/2, format: :json
      Player.find(@player2.id).turn.should be_true
    end

    xit 'calculates hits' do
      put :take_turn, player_id:@player1.id, x: @grid1.columns/2, y: @grid1.rows/2, format: :json
      GamesController.should_receive(:calculate_hits).once
    end
  end

end


