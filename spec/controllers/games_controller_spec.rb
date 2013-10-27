require 'spec_helper'

# The documentation used as reference for writing these tests can be found in: https://www.relishapp.com/rspec/rspec-rails/v/2-1/docs/controller-specs/render-views

describe GamesController do

  render_views

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


  context '#my_turn' do

    before do
      @player = Player.create(name: 'grace', turn: true)
    end

    it 'tells a player if it is his/her turn' do
      get :my_turn, player_id: 1, format: :json

      response.should be_true
    end

  end

  context 'my_turn validations' do

    it 'turn coordinates submitted are inside battle grid' do
      player = FactoryGirl.create(:player)
      put :my_turn, player_id:player.id, x:3, y:3, format: :xml
      response.should render_template :my_turn
    end

  end

end


