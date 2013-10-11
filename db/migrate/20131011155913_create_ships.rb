class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.integer :x_start
      t.string :x_end
      t.integer :
      t.string :y_start
      t.integer :
      t.string :y_end
      t.integer :
      t.string :state
      t.text :
      t.string :name

      t.timestamps
    end
  end
end
