require 'spec_helper'

describe Ship do

  context "attribute access check" do

    before do
      @ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3, state: nil)
    end

    subject { @ship }

    it { should respond_to(:name) }
    it { should respond_to(:x_start) }
    it { should respond_to(:x_end) }
    it { should respond_to(:y_start) }
    it { should respond_to(:y_end) }
    it { should respond_to(:state) }

  end

  context "arrangement" do

    it "raises error if ship is saved without name" do
      ship = Ship.new(x_start: 1, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "raises error if ship's name is not one among the accepted names" do
      ship = Ship.new(name: "Plane", x_start: 1, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end


  end


end
