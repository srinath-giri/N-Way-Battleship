require 'spec_helper'

describe Player do

  it "validate an error is thrown when creating a player with empty name" do
    grace = Player.new(name: "")

    grace.should_not be_valid
    grace.should have(1).error_on(:name)
  end

  xit "has a unique name" do

  end

  xit "has 5 ships" do

  end



end
