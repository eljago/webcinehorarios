class AddDefaultDurationToShows < ActiveRecord::Migration
  def change
    change_column :shows, :duration, :integer, default: 0, null: false
  end
end
