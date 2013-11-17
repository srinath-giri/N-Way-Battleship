require 'spec_helper'

describe PlayersController do

  context '#pass_turn' do
    before(:each) do
      @player1 = FactoryGirl.create(:player1, turn: false)
      @player2 = FactoryGirl.create(:player2, turn: false)
      @player3 = FactoryGirl.create(:player3, turn: false )
      @player4 = FactoryGirl.create(:player4, turn: false )

      @players = [@player4, @player3, @player1, @player2]
    end

    it "passes the token to the player with the first ID if no player has the token" do
      PlayersController.pass_turn(@players)
      @player1.turn.should be_true
    end

    it "passes the token to the second player if the first player has the token" do
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

    it "ensures only one player has the token at all times" do
      @player1.turn = true
      PlayersController.pass_turn(@players)
      sum_turns = @players.inject(0) { |sum, player| sum + (player.turn ? 1 : 0) }
      sum_turns.should == 1

      @player2.turn = true
      PlayersController.pass_turn(@players)
      sum_turns = @players.inject(0) { |sum, player| sum + (player.turn ? 1 : 0) }
      sum_turns.should == 1

      @player3.turn = true
      PlayersController.pass_turn(@players)
      sum_turns = @players.inject(0) { |sum, player| sum + (player.turn ? 1 : 0) }
      sum_turns.should == 1

      @player4.turn = true
      PlayersController.pass_turn(@players)
      sum_turns = @players.inject(0) { |sum, player| sum + (player.turn ? 1 : 0) }
      sum_turns.should == 1
    end
  end

end
