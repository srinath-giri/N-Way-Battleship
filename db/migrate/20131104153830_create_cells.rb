class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.integer :x
      t.integer :y
      t.string :state
      t.integer :grid_id

      t.timestamps
    end
  end
end
