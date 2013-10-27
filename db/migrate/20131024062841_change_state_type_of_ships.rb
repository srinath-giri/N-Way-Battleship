class ChangeStateTypeOfShips < ActiveRecord::Migration
  def up
  	change_column :ships, :state, :text
  end

  def down
  	change_column :ships, :state, :string
  end
end
