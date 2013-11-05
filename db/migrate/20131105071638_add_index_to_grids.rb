class AddIndexToGrids < ActiveRecord::Migration
  def change
    add_column :grids, :player_id, :integer
  end
end
