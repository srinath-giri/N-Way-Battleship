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
end
  

