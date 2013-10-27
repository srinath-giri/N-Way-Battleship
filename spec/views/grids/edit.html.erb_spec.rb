require 'spec_helper'

describe "grids/edit" do
  before(:each) do
    @grid = assign(:grid, stub_model(Grid,
      :rows => 1,
      :columns => 1,
      :player_id => 1
    ))
  end

  # it "renders the edit grid form" do
  #     render 
  # 
  #     # Run the generator again with the --webrat flag if you want to use webrat matchers
  #     assert_select "form[action=?][method=?]", grid_path(@grid), "post" do
  #       assert_select "input#grid_rows[name=?]", "grid[rows]"
  #       assert_select "input#grid_columns[name=?]", "grid[columns]"
  #       assert_select "input#grid_player_id[name=?]", "grid[player_id]"
  #     end

  
end
