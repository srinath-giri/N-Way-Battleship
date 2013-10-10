require 'spec_helper'

describe Miss do
  it "belongs to a player" do
    Miss.validates_associated(:player)
  end

end
