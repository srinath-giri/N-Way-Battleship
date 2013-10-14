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
    end
  end

end


