class AddTypeToGrids < ActiveRecord::Migration
  def change
    add_column :grids, :type, :string
  end
end
