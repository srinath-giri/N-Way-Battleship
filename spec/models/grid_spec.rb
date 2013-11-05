require 'spec_helper'

describe Grid do

  before do
    @player = Player.first
    if @player == nil
      @player = Player.create(name: 'test2', turn: true)
    end
  end

  context '#create_grid_for_player' do

    it "returns a grid with grid_type 'battlefield', when battlefield parameter is passed" do
      @battlefield_grid = Grid.create_grid_for_player('battlefield', @player)
      @battlefield_grid.grid_type.should == 'battlefield'
    end

    it "returns a grid with grid_type 'my_ships', when my_ships parameter is passed" do
      @my_ships_grids = Grid.create_grid_for_player('my_ships', @player)
      @my_ships_grids.grid_type.should == 'my_ships'
    end

  end

  context '#initialize_battlefield_grid' do
    it "should have 100 cells" do
      @battlefield_grid = Grid.create_grid_for_player('battlefield', @player)
      Grid.initialize_battlefield_grid(@battlefield_grid)
      @battlefield_grid.cells.count.should == 100
    end
  end

  context '#initialize_my_ships_grid' do
    it "should have 17 cells" do
      @my_ships_grids = Grid.create_grid_for_player('my_ships', @player)
      Grid.initialize_my_ships_grid(@my_ships_grids)
      @my_ships_grids.cells.count.should == 17
    end
  end


end
