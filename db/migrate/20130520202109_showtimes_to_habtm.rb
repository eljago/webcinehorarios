class ShowtimesToHabtm < ActiveRecord::Migration
  def change
    remove_timestamps :function_types
    remove_timestamps :genres
    remove_timestamps :showtimes
    remove_column :showtimes, :function_id
    
    create_table :function_showtimes, id: false do |t|
      t.integer :function_id
      t.integer :showtime_id
    end
    add_index :function_showtimes, :function_id
    add_index :function_showtimes, :showtime_id
  end
end
