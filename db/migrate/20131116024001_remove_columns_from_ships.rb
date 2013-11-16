class RemoveColumnsFromShips < ActiveRecord::Migration
  def up
    remove_column :ships, :x_start
    remove_column :ships, :x_end
    remove_column :ships, :y_start
    remove_column :ships, :y_end
    remove_column :ships, :state
  end

  def down
    add_column :ships, :state, :string
    add_column :ships, :y_end, :integer
    add_column :ships, :y_start, :integer
    add_column :ships, :x_end, :integer
    add_column :ships, :x_start, :integer
  end
end
