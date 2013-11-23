class AddGameStatusToGames < ActiveRecord::Migration
  def change
    add_column :games, :game_status, :string
  end
end
