class AddPlayerIdToShips < ActiveRecord::Migration
  def change
    add_column :ships, :player_id, :integer
  end
end
