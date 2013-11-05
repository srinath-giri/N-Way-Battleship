class ChangeStateFormatInCell < ActiveRecord::Migration
  def up
    change_column :cells, :state, :text
  end

  def down
    change_column :cells, :state, :string
  end
end
