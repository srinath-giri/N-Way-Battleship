class RenameType < ActiveRecord::Migration
  def up
    rename_column :grids, :type, :grid_type
  end

  def down
  end
end
