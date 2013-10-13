require 'spec_helper'

describe Ship do

  context "check attribute access" do

    before do
      @ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 4, state: nil)
    end

    subject { @ship }

    it { should respond_to(:name) }
    it { should respond_to(:x_start) }
    it { should respond_to(:x_end) }
    it { should respond_to(:y_start) }
    it { should respond_to(:y_end) }
    it { should respond_to(:state) }

  end

  context "arrange ships" do

    it "raises error if saved without name" do
      ship = Ship.new
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "raises error if saved without grid points" do
      ship = Ship.new(name: "Destroyer")
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end
