require 'spec_helper'

describe Ship do

  subject { FactoryGirl.build(:ship) }

  context "attribute access check" do
    it { should respond_to(:name) }
  end

  context "arrangement" do

    it "raises error if ship is saved without name" do
      subject.name = nil
      expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "raises error if ship's name is not one among the accepted names" do
      subject.name = "Plane"
      expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "does not raise error if ship's name is among the accepted names" do
      subject.name = "Destroyer"
      expect { subject.save! }.to_not raise_error
    end

  end

end
