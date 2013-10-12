require 'spec_helper'

describe PlayersController do

  before do
    @player1 = Player.create(name: "Grace", turn: false)      # created with id 1
    @player2 = Player.create(name: "Ibrahim", turn: false)    # created with id 2
    @player3 = Player.create(name: "Owen", turn: false)       # created with id 3
    @player4 = Player.create(name: "Srinath", turn: false)    # created with id 4

    @players = [@player4, @player3, @player1, @player2]
  end

  it "passes the token to the player with the first ID if no player has the token" do
    PlayersController.pass_turn(@players)
    @player1.turn.should be_true
  end

  it "passes the token to the second player if the first players has the token" do
    @player1.turn = true
    PlayersController.pass_turn(@players)
    @player1.turn.should be_false
    @player2.turn.should be_true
  end

  it "passes the token to the first player if the last player has the token" do
    @player4.turn = true
    PlayersController.pass_turn(@players)
    @player4.turn.should be_false
    @player1.turn.should be_true
  end

end
