class DestroyOldShowtimes < ActiveRecord::Migration
  def up
    Showtime.where('showtimes.time < ?',Date.current).destroy_all
  end

  def down
  end
end
