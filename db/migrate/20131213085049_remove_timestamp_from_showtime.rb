class RemoveTimestampFromShowtime < ActiveRecord::Migration
  def change
    remove_timestamps :showtimes
  end
end
