require 'spec_helper'

describe Grid do
  before :each do
    @grid = Grid.new(player_id: 1, grid_type: "battlefield")
  end
  
  context "attribute access" do
    subject { @grid }
    it { should respond_to(:player_id) }
    it { should respond_to(:grid_type) }
  end

  context "grid validations" do

    it "Grid type is either battlefield or my_ships" do
      grid = Grid.new(player_id: 1, grid_type: "bf")
      expect { grid.save! }.to raise_error(ActiveRecord::RecordInvalid)
      grid = Grid.new(player_id: 1, grid_type: "battlefield")
      expect { grid.save! }.to change { Grid.count }.by(1)
      grid = Grid.new(player_id: 1, grid_type: "my_ships")
      expect { grid.save! }.to change { Grid.count }.by(1)
    end

  end

end
  

