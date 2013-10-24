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

    it "ship is saved if ship's name is one among the accepted names" do
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to change { Ship.count }.by(1)
    end

    it "raises error if ship is saved without grid points" do
      ship = Ship.new(name: "Destroyer")
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "raises error if ship is saved with non-positive or non-integer grid points" do
      ship = Ship.new(name: "Destroyer", x_start: 1.5, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: -1, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 'A', x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)

      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1.5, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: -1, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 'A', y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)

      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1.5, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: -1, y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 'A', y_end: 3)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)

      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 1.5)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: -1)
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 'A')
      expect { ship.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "raises error if ship is saved with starting grid point to the right of ending grid point" do
      ship = Ship.new(name: "Destroyer", x_start: 3, x_end: 1, y_start: 1, y_end: 1)
      expect { ship.save! }.to raise_error(Ship::InvalidGridPoint)
    end

    it "raises error if ship is saved with starting grid point to the bottom of ending grid point" do
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 3, y_end: 1)
      expect { ship.save! }.to raise_error(Ship::InvalidGridPoint)
    end

    it "raises error if the distance of grid points does not match with the ship's size" do
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 7)
      expect { ship.save! }.to raise_error(Ship::InvalidGridPoint)
      ship = Ship.new(name: "Battleship", x_start: 1, x_end: 1, y_start: 1, y_end: 5)
      expect { ship.save! }.to raise_error(Ship::InvalidGridPoint)
      ship = Ship.new(name: "Carrier", x_start: 1, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(Ship::InvalidGridPoint)
      ship = Ship.new(name: "Submarine", x_start: 1, x_end: 1, y_start: 1, y_end: 2)
      expect { ship.save! }.to raise_error(Ship::InvalidGridPoint)
      ship = Ship.new(name: "PatrolBoat", x_start: 1, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to raise_error(Ship::InvalidGridPoint)
    end

    it "ship is saved if the distance of grid points matches with the ship's size" do
      ship = Ship.new(name: "Destroyer", x_start: 1, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to change { Ship.count }.by(1)
      ship = Ship.new(name: "Battleship", x_start: 1, x_end: 1, y_start: 1, y_end: 4)
      expect { ship.save! }.to change { Ship.count }.by(1)
      ship = Ship.new(name: "Carrier", x_start: 1, x_end: 1, y_start: 1, y_end: 5)
      expect { ship.save! }.to change { Ship.count }.by(1)
      ship = Ship.new(name: "Submarine", x_start: 1, x_end: 1, y_start: 1, y_end: 3)
      expect { ship.save! }.to change { Ship.count }.by(1)
      ship = Ship.new(name: "PatrolBoat", x_start: 1, x_end: 1, y_start: 1, y_end: 2)
      expect { ship.save! }.to change { Ship.count }.by(1)
    end

  end


end
