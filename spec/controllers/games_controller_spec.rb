require 'spec_helper'

# The documentation used as reference for writing these tests can be found in: https://www.relishapp.com/rspec/rspec-rails/v/2-1/docs/controller-specs/render-views

describe GamesController do

  render_views
  # Why we render the views explanation:   http://stackoverflow.com/questions/9027518/what-does-render-views-do-in-rspec
  # "it renders the view's in the controller spec. If you don't put render_views, the views won't render,
  # that means the controller is called but after it returns the views are not rendered.
  # Controller tests will run faster, as they won't have to render the view, but you might miss bugs in the view."

  describe "arrange ships" do
    it "renders the arrange_ships template" do
      get :arrange_ships
      response.should contain(/[Aa]rrange/)
    end
  end

  describe "play" do
    it "renders the play template" do
      get :play
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

  end

  context 'calculate_hits' do
    before do
      @player1 = Player.create(name: 'grace', turn: true)
      @player2 = Player.create(name: 'ibrahim', turn: false)
      @player3 = Player.create(name: 'owen', turn: false)
      @player1.ships.create(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
      @player2.ships.create(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
      @player3.ships.create(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
    end

    it 'can change ship hit status when the attack is within range' do
      xhr :post, :calculate_hits, player_id: @player1.id, x: 1, y: 2
      @player2.ships.first.state[1].should == @player1.id    
    end

    it 'does not change ship hit status when the attack is out of range' do
      xhr :post, :calculate_hits, player_id: @player1.id, x: 2, y: 2
      @player2.ships.first.state.should == nil
    end

    it 'does not change ships hit status of attacker' do
      xhr :post, :calculate_hits, player_id: @player1.id, x: 1, y: 2
      @player1.ships.first.state.should == nil
    end

    it 'does not change ships hit status if the slot of ship has already been hit' do
      xhr :post, :calculate_hits, player_id: @player1.id, x: 1, y: 2
      xhr :post, :calculate_hits, player_id: @player3.id, x: 1, y: 2
      @player2.ships.first.state[1].should == @player1.id
    end


    it 'can change status of multiple ships if player hit more than one ship' do
      xhr :post, :calculate_hits, player_id: @player1.id, x: 1, y: 2
      @player2.ships.first.state[1].should == @player1.id
      @player3.ships.first.state[1].should == @player1.id
     end

    end


  context 'take turn validations' do

    before do
      @player = FactoryGirl.create(:player)
      @grid = FactoryGirl.create(:grid)
    end

    it 'turn coordinates submitted inside battle grid are accepted' do
      put :take_turn, player_id:@player.id, x: @grid.columns/2, y: @grid.rows/2, format: :json
      JSON.parse(response.body)['turn'].should be_false
    end

    it 'turn coordinates submitted outside battle grid are not accepted' do
      put :take_turn, player_id:@player.id, x: @grid.columns+100, y: @grid.rows+100, format: :json
      JSON.parse(response.body)['error'].should be_true
      JSON.parse(response.body)['turn'].should be_true
    end

    it 'turn ends after taking a proper shot' do
      put :take_turn, player_id:@player.id, x: @grid.columns/2, y: @grid.rows/2, format: :json
      JSON.parse(response.body)['turn'].should be_false
    end

  end

end


