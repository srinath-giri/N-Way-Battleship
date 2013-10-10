class CreateMisses < ActiveRecord::Migration
  def change
    create_table :misses do |t|
      t.integer :x
      t.integer :y
      t.integer :player_id

      t.timestamps
    end
  end
end
