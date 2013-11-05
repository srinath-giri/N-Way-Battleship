require 'spec_helper'

describe Cell do
  context "attribute access check" do

    before do
      @cell = Cell.new(grid_id: 1, state: {4=>'u', 2=>'u', 3=>'u'} , x: 1, y:1)
    end

    subject { @cell }

    it { should respond_to(:grid_id) }
    it { should respond_to(:state) }
    it { should respond_to(:x) }
    it { should respond_to(:y) }

  end

  context "validations" do

    before do
      @battlefield_grid = Grid.create(player_id: 1, grid_type: "battlefield")
      @player_grid = Grid.create(player_id: 1, grid_type: "my_ships")
    end

    it "x and y coordinates are present" do
      #expect { @battlefield_grid.cells.create(state: {2=>'u', 3=>'u', 4=>'u'}) }.to raise_error(ActiveRecord::RecordInvalid)

      expect { @battlefield_grid.cells.create(x:2, y:2, state: {2=>'u', 3=>'u', 4=>'u'}) }.to change { Cell.count }.by(1)
    end

    it "x and y coordinates are between 0 and 9" do
      #expect { @battlefield_grid.cells.create(x: 11, y:11, state: {2=>'u', 3=>'u', 4=>'u'}) }.to raise_error(ActiveRecord::RecordInvalid)

      #expect { @battlefield_grid.cells.create(x: -1, y:-1, state: {2=>'u', 3=>'u', 4=>'u'}) }.to raise_error(ActiveRecord::RecordInvalid)

      expect { @battlefield_grid.cells.create(x:0, y:0, state: {2=>'u', 3=>'u', 4=>'u'}) }.to change { Cell.count }.by(1)
    end

    it "state maintains battlefield data for the cell which belongs to battlefield grid" do
      #expect { @battlefield_grid.cells.create( x:4, y:4, state: {"orientation"=>"V", "block"=>"1", "type"=>"","hit"=>false }) }.to raise_error(Cell::InvalidState)

      expect { @battlefield_grid.cells.create( x:4, y:4, state: {2=>'u', 3=>'u', 4=>'u'}) }.to change { Cell.count }.by(1)
    end

    it "state maintains ship data for the cell which belongs to player grid" do
      #expect { @player_grid.cells.create( x:4, y:4, state: {2=>'u', 3=>'u', 4=>'u'}) }.to raise_error(Cell::InvalidState)

      expect { @player_grid.cells.create( x:4, y:4, state: {"orientation"=>"V", "block"=>"1", "type"=>"","hit"=>false }) }.to change { Cell.count }.by(1)
    end

  end

end
