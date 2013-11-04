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

  
  

  context 'take turn' do

    before do
      @player1 = FactoryGirl.create(:player, id:1, name:"Player1", turn:true)
      @player2 = FactoryGirl.create(:player, id:2, name:"Player2", turn:false)
      @grid1 = FactoryGirl.create(:grid,player_id:1)
      @grid2 = FactoryGirl.create(:grid,player_id:2)
    end

    it 'is not allowed for a player when it is not his turn' do
      put :take_turn, player_id:@player2.id, x: 5, y: 5, format: :json
      JSON.parse(response.body)['error'].should be_true
      JSON.parse(response.body)['turn'].should be_false
    end

    it 'coordinates submitted outside battle grid are not accepted' do
      put :take_turn, player_id:@player1.id, x: 105, y: 105, format: :json
      JSON.parse(response.body)['error'].should be_true
      JSON.parse(response.body)['turn'].should be_true

      put :take_turn, player_id:@player1.id, x: -1, y: -1, format: :json
      JSON.parse(response.body)['error'].should be_true
      JSON.parse(response.body)['turn'].should be_true

    end

    it 'coordinates submitted inside battle grid are accepted' do
      put :take_turn, player_id:@player1.id, x: 5, y:5, format: :json
      JSON.parse(response.body)['turn'].should be_false
    end

    it 'passes turn to next player after taking a proper shot' do
      put :take_turn, player_id:@player1.id, x: 5, y: 5, format: :json
      Player.find(@player2.id).turn.should be_true
    end

    xit 'calculates hits' do
      put :take_turn, player_id:@player1.id, x: 5, y: 5, format: :json
      GamesController.should_receive(:calculate_hits).once
    end
  end

end


