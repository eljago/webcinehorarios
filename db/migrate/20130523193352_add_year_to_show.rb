class AddYearToShow < ActiveRecord::Migration
  def change
    add_column :shows, :year, :integer
    add_column :shows, :active, :boolean
  end
end
