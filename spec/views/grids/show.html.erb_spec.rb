require 'spec_helper'

describe "grids/show" do
  before(:each) do
    @grid = assign(:grid, stub_model(Grid,
      :rows => 1,
      :columns => 2,
      :player_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
