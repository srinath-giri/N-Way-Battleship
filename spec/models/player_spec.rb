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
    maria.should have(1).error_on(:name)

  end

  context '#get_battlefield_grid' do
    before do
      @player = Player.first
      if @player == nil
        @player = Player.create(name: 'test2', turn: true)
      end
    end

    it "returns a grid with grid_type 'battlefield'" do
      @player.get_battlefield_grid.grid_type.should == 'battlefield'
    end

    it "returns a grid with grid_type 'my_ships'" do
      @player.get_my_ships_grid.grid_type.should == 'my_ships'
    end

  end


end
