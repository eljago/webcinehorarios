class AddDefaultYearToShow < ActiveRecord::Migration
  def change
    change_column :shows, :year, :integer, default: 0, null: false
  end
end
