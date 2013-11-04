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


end
