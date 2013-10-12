require 'spec_helper'

describe PlayersController do

  it "passes the token to the player with the first ID if no player has the token" do
    player1 = Player.create(name: "Grace", turn: false)
    player2 = Player.create(name: "Ibrahim", turn: false)
    player3 = Player.create(name: "Owen", turn: false)
    player4 = Player.create(name: "Srinath", turn: false)

    PlayersController.passTurn

    player1.turn.should be_true
  end

end
