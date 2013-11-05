class RemoveRowsFromGrids < ActiveRecord::Migration
  def up
    remove_column :grids, :rows
  end

  def down
    add_column :grids, :rows, :integer
  end
end
