require 'spec_helper'

describe Game do

  context "attribute access check" do
    it {should respond_to(:number_of_players) }
    it {should respond_to(:game_status) }
  end

  context "associations check" do
    it {should respond_to(:players) }
  end

  context "attribute validations" do

    subject { FactoryGirl.build(:game) }

    it "validates number of players is integer" do
      subject.number_of_players = "four"
      subject.should_not be_valid
      subject.errors[:number_of_players].should include("is not a number")

      subject.number_of_players = 4
      subject.should be_valid
    end

    it "validates number of players is between 2 and 10" do
      subject.number_of_players = 0
      subject.should_not be_valid
      subject.errors[:number_of_players].should include("should be between 2 and 10")

      subject.number_of_players = 1
      subject.should_not be_valid
      subject.errors[:number_of_players].should include("should be between 2 and 10")

      subject.number_of_players = 12
      subject.should_not be_valid
      subject.errors[:number_of_players].should include("should be between 2 and 10")

      subject.number_of_players = 4
      subject.should be_valid
    end

    it "validates game status has a valid status" do
      subject.game_status = "whatever"
      expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)

      subject.game_status = "waiting"
      expect { subject.save! }.to_not raise_error
    end

  end

end
