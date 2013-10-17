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

  context '#is_it_my_turn' do

    before do
      @player = Player.create(name: 'grace', turn: true)
    end

    it 'returns true if it is his/her turn' do
      get :is_it_my_turn, player_id: 1, format: :json
      JSON.parse(response.body)['turn'].should be_true
    end

    it 'returns false if it is not his/her turn' do
      @player.update_attributes(turn: false)
      get :is_it_my_turn, player_id: 1, format: :json
      JSON.parse(response.body)['turn'].should be_false
    end

    it 'updates the "play" view if the player has the turn' do
      pending
    end

  end


end


