require 'spec_helper'


describe Player do

  it "validate an error is thrown when creating a player with empty name" do
    grace = Player.new(name: "")

    grace.should_not be_valid
    grace.should have(1).error_on(:name)
  end



  it "has a unique name" do
    grace = Player.create(name: "grace")
    maria = Player.create(name: "grace")

    maria.should_not be_valid

  end


  xit "has 5 ships" do

  end


    xit "make sure that only one player has the token to take the turn" do
      #grace = Player.new(name: "grace", turn: null)
    end



    xit "passing the token to the first player when no one has the token" do

    end

end
