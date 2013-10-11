class Ship < ActiveRecord::Base
  attr_accessible :name, :state, :x_end, :x_start, :y_end, :y_start
  #def initialize(name, x_start, x_end, y_start, y_end, state)

  #end
end
