require 'spec_helper'

describe Ship do

  before do
    @ship = Ship.new(name:"Destroyer", x_start:1, x_end:1, y_start:2, y_end:2, state:nil) 
     

  end

  subject {@ship}

  it {should respond_to(:name)}
  it {should respond_to(:x_start)}
  it {should respond_to(:x_end)}
  it {should respond_to(:y_start)}
  it {should respond_to(:y_end)}
  it {should respond_to(:state)}

end
