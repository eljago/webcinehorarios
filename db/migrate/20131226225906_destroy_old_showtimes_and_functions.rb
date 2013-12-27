class DestroyOldShowtimesAndFunctions < ActiveRecord::Migration
  def up
    Showtime.where('showtimes.time < ?',DateTime.current).destroy_all
    Function.where('functions.date < ?',Date.current).destroy_all
  end

  def down
  end
end
