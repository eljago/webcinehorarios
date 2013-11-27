class ReCreateLatitudeLongitudeOnTheaters < ActiveRecord::Migration
  def change
    remove_column :theaters, :latitude
    remove_column :theaters, :longitude
    add_column :theaters, :latitude, :decimal, :precision => 15, :scale => 10
    add_column :theaters, :longitude, :decimal, :precision => 15, :scale => 10
  end
end
