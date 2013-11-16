require 'spec_helper'

describe Move do
  subject { FactoryGirl.build(:move) }

  context "attribute access check" do
    it { should respond_to(:x) }
    it { should respond_to(:y) }
    it { should respond_to(:player_id) }
  end

end
