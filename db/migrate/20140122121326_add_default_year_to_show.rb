class AddDefaultYearToShow < ActiveRecord::Migration
  def up
    change_column :shows, :year, :integer, default: 0, null: false
  end
  def down
    change_column :shows, :year, :integer
  end
end
