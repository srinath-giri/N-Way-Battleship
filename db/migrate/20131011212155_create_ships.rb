class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name
      t.integer :x_start
      t.integer :x_end
      t.integer :y_start
      t.integer :y_end
      t.string :state

      t.timestamps
    end
  end
end
