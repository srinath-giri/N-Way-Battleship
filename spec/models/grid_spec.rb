require 'spec_helper'

describe Grid do
  before :each do
    @grid = Grid.new(rows: 5, columns: 5, player_id: 1)
  end
  
  context "initialise grid check" do
  subject { @grid }
  
  it { should respond_to(:columns) }
  it { should respond_to(:rows) }
  
  it "has 5 columns" do
    @grid.columns.should == 5 
  end
   
  it "has 5 rows" do
    @grid.rows.should == 5 
  end 
  
  context "each player has grid" do
    subject { @grid }
    it { should respond_to(:player_id) }
    
  end
end
  
end
