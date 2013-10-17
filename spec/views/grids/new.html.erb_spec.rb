require 'spec_helper'

describe "grids/new" do
  before(:each) do
    assign(:grid, stub_model(Grid,
      :rows => 1,
      :columns => 1,
      :player_id => 1
    ).as_new_record)
  end

  it "renders new grid form" do
    render 

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", grids_path, "post" do
      assert_select "input#grid_rows[name=?]", "grid[rows]"
      assert_select "input#grid_columns[name=?]", "grid[columns]"
      assert_select "input#grid_player_id[name=?]", "grid[player_id]"
    end
  end
end
