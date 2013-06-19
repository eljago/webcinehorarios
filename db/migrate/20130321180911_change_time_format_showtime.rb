class ChangeTimeFormatShowtime < ActiveRecord::Migration
  def up
    change_column :showtimes, :time, :time
    add_column :functions, :date, :date
  end

  def down
    remove_column :functions, :date, :date
    change_column :showtimes, :time, :datetime
  end
end
