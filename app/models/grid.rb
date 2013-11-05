class Grid < ActiveRecord::Base


  belongs_to :player
  attr_accessible :columns, :player_id, :rows
  attr_accessible :columns, :player_id, :rows, :grid_type

  attr_accessible :player_id, :grid_type


  belongs_to :player
  has_many :cells, dependent: :destroy


  # validates_presence_of(:player_id)
  # validates_numericality_of(:player_id, :only_integer => true, :greater_than_or_equal_to => 1)


  def self.create_grid_for_player(grid_type, player)

    grid = Grid.where("player_id = ? AND grid_type = ?", player.id, grid_type).first

    # Create the grid if it doesn't exist
    if grid == nil
      grid = player.grids.create(grid_type: grid_type)

      # Create the cells
      if grid_type == 'battlefield'
        initialize_battlefield_grid(grid)
      elsif grid_type == 'my_ships'
        initialize_my_ships_grid(grid)
      end

    end

    grid

  end

  def self.initialize_battlefield_grid(grid)

    state = {}

    # initialize state: other players' have the 'unknown' state
    other_players = Player.select(:id).where("id <> ?", grid.player_id)

    other_players.each do |player|
      state[player.id.to_s] = 'u'
    end

    # Delete existing records, if any
    grid.cells.destroy_all

    # create a record for each cell of the grid
    10.times do |x|
      10.times do |y|
        grid.cells.create(x: x, y: y, state: state)
      end
    end

  end



  def self.initialize_my_ships_grid(grid)

    # carrier     5
    # battleship  4
    # destroyer   3
    # submarine   3
    # patrol boat 2

    ship_cells = []

    # carrier     5
    ship_cells[0] = {
        x: 0,
        y: 0,
        state: {
            orientation: :v,
            block: 1,
            type: :c,
            hit: false
        }
    }
    ship_cells[1] = {
        x: 0,
        y: 1,
        state: {
            orientation: :v,
            block: 2,
            type: :c,
            hit: false
        }
    }
    ship_cells[2] = {
        x: 0,
        y: 2,
        state: {
            orientation: :v,
            block: 3,
            type: :c,
            hit: false
        }
    }
    ship_cells[3] = {
        x: 0,
        y: 3,
        state: {
            orientation: :v,
            block: 4,
            type: :c,
            hit: false
        }
    }
    ship_cells[4] = {
        x: 0,
        y: 4,
        state: {
            orientation: :v,
            block: 5,
            type: :c,
            hit: false
        }
    }

    # battleship  4
    ship_cells[5] = {
        x: 6,
        y: 0,
        state: {
            orientation: :h,
            block: 1,
            type: :b,
            hit: false
        }
    }
    ship_cells[6] = {
        x: 7,
        y: 0,
        state: {
            orientation: :h,
            block: 2,
            type: :b,
            hit: false
        }
    }
    ship_cells[7] = {
        x: 8,
        y: 0,
        state: {
            orientation: :h,
            block: 3,
            type: :b,
            hit: false
        }
    }
    ship_cells[8] = {
        x: 9,
        y: 0,
        state: {
            orientation: :h,
            block: 4,
            type: :b,
            hit: false
        }
    }

    # destroyer   3
    ship_cells[9] = {
        x: 2,
        y: 1,
        state: {
            orientation: :v,
            block: 1,
            type: :d,
            hit: false
        }
    }
    ship_cells[10] = {
        x: 2,
        y: 2,
        state: {
            orientation: :v,
            block: 2,
            type: :d,
            hit: false
        }
    }
    ship_cells[11] = {
        x: 2,
        y: 3,
        state: {
            orientation: :v,
            block: 3,
            type: :b,
            hit: false
        }
    }

    # submarine   3
    ship_cells[12] = {
        x: 4,
        y: 2,
        state: {
            orientation: :v,
            block: 1,
            type: :s,
            hit: false
        }
    }
    ship_cells[13] = {
        x: 4,
        y: 3,
        state: {
            orientation: :v,
            block: 2,
            type: :s,
            hit: false
        }
    }
    ship_cells[14] = {
        x: 4,
        y: 4,
        state: {
            orientation: :v,
            block: 3,
            type: :s,
            hit: false
        }
    }

    # patrol boat 2
    ship_cells[15] = {
        x: 8,
        y: 8,
        state: {
            orientation: :h,
            block: 1,
            type: :p,
            hit: false
        }
    }
    ship_cells[16] = {
        x: 9,
        y: 8,
        state: {
            orientation: :h,
            block: 2,
            type: :p,
            hit: false
        }
    }

    # Delete existing records, if any
    # grid.cells.destroy_all
    # 
    # 
    #     ship_cells.each do |cell|
    #       grid.cells.create(x: cell[:x], y: cell[:y], state: cell[:state])
    #     end
    
  end


  # validates_inclusion_of :grid_type, :in => %w( battlefield my_ships )

end
