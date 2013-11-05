class RemoveColumnsFromGrids < ActiveRecord::Migration
  def up
    remove_column :grids, :columns
  end

  def down
    add_column :grids, :columns, :integer
  end
end
