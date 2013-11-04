class AddIndexToGrids < ActiveRecord::Migration
  def change
    add_index :grids, :player_id, :unique => true
  end
end
