require 'spec_helper'

describe "grids/index" do
  before(:each) do
    assign(:grids, [
      stub_model(Grid,
        :rows => 1,
        :columns => 2,
        :player_id => 3
      ),
      stub_model(Grid,
        :rows => 1,
        :columns => 2,
        :player_id => 3
      )
    ])
  end

  it "renders a list of grids" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
