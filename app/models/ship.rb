class Ship < ActiveRecord::Base
  attr_accessible :name, :state, :x_end, :x_start, :y_end, :y_start
  validates_presence_of(:name)
  validates_presence_of(:x_start)
  validates_presence_of(:x_end)
  validates_presence_of(:y_start)
  validates_presence_of(:y_end)
end
