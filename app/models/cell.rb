class Cell < ActiveRecord::Base
  attr_accessible :grid_id, :state, :x, :y
  serialize :state

  belongs_to :grid

  validates_presence_of(:x)
     validates_numericality_of(:x, :only_integer => true)
     validates_inclusion_of(:x, :in => 0..9)

     validates_presence_of(:y)
     validates_numericality_of(:y, :only_integer => true)
     validates_inclusion_of(:y, :in => 0..9)

     before_create :validate_state!

  class InvalidState < ActiveRecord::RecordInvalid
  end

  def validate_state!

    @grid = Grid.find(grid_id)
    if(@grid.grid_type == "battlefield")
      if(state.has_key?("orientation") || state.has_key?("block") || state.has_key?("type") || state.has_key?("hit") )
        raise InvalidState, "Cell State should be the type required for battlefield type"
      end
    end

    if(@grid.grid_type == "my_ships")
      if ( state.has_key?("orientation") || state.has_key?(:orientation) ) && (state.has_key?("block")  || state.has_key?(:block) ) && (state.has_key?("type")   || state.has_key?(:type) ) && (state.has_key?("hit")  || state.has_key?(:hit)  )
      else
        raise InvalidState, "Cell State does not have all the required details"
      end
    end

  end

end
