class RemoveIndexFromGrids < ActiveRecord::Migration
  def up
    remove_column :grids, :player_id
  end

  def down
    add_column :grids, :player_id, :integer
  end
end
