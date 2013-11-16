require 'spec_helper'

describe Cell do

  subject { FactoryGirl.build(:cell) }

  before do
    @cell = Cell.new(grid_id: 1, state: {4=>'u', 2=>'u', 3=>'u'} , x: 1, y:1)
  end

  context "attribute access check" do

    it { should respond_to(:grid_id) }
    it { should respond_to(:state) }
    it { should respond_to(:x) }
    it { should respond_to(:y) }

  end

  context "validations" do

    before do
      @battlefield_cell = FactoryGirl.create(:battlefield_cell)
      @my_ships_cell = FactoryGirl.create(:my_ships_cell)
   end

    it "x and y coordinates are present" do
      @battlefield_cell.x = nil
      @battlefield_cell.y = nil
      expect { @battlefield_cell.save! }.to raise_error(ActiveRecord::RecordInvalid)

      @battlefield_cell.x = 2
      @battlefield_cell.y = 2
      expect { @battlefield_cell.save! }.to_not raise_error
    end

    it "x and y coordinates are between 0 and 9" do
      @battlefield_cell.x = 11
      @battlefield_cell.y = 11
      expect { @battlefield_cell.save!}.to raise_error(ActiveRecord::RecordInvalid)
      @battlefield_cell.x = -1
      @battlefield_cell.y = -1
      expect { @battlefield_cell.save!}.to raise_error(ActiveRecord::RecordInvalid)
      @battlefield_cell.x = 0
      @battlefield_cell.y = 0
      expect { @battlefield_cell.save! }.to_not raise_error
    end

    it "state maintains battlefield data for the cell which belongs to battlefield grid" do
      @battlefield_cell.state = {"orientation"=>"V", "block"=>"1", "type"=>"Destroyer","hit"=>false }
      expect { @battlefield_cell.save! }.to raise_error(RuntimeError)
      @battlefield_cell.state = {2=>'u', 3=>'u', 4=>'u'}
      expect { @battlefield_cell.save! }.to_not raise_error
    end

    it "state maintains ship data for the cell which belongs to player grid" do
      @my_ships_cell.state = {2=>'u', 3=>'u', 4=>'u'}
      expect { @my_ships_cell.save! }.to raise_error(RuntimeError)
      @my_ships_cell.state = {"orientation"=>"V", "block"=>"1", "type"=>"Destroyer","hit"=>false }
      expect { @my_ships_cell.save! }.to_not raise_error
    end

  end

end
