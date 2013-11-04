class AddIndexToShips < ActiveRecord::Migration
  def change
    add_index :ships, :player_id, :unique => true
  end
end
