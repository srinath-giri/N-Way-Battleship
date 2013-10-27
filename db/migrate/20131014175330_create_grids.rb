class CreateGrids < ActiveRecord::Migration
  def change
    create_table :grids do |t|
      t.integer :rows
      t.integer :columns
      t.integer :player_id

      t.timestamps
    end
  end
end
