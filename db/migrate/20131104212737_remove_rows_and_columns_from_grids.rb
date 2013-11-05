class RemoveRowsAndColumnsFromGrids < ActiveRecord::Migration
  def up
    remove_column :grids, :columns
    remove_column :grids, :rows
  end

  def down
    add_column :grids, :rows, :integer
    add_column :grids, :columns, :integer
  end
end
