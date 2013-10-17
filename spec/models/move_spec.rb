require 'spec_helper'

describe Move do
  before do
    @move = Move.new(x: 1, y: 1, player_id: 1)
  end

  subject { @move }

  it { should respond_to(:x) }
  it { should respond_to(:y) }
  it { should respond_to(:player_id) }
end
