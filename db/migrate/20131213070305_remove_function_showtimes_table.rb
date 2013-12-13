class RemoveFunctionShowtimesTable < ActiveRecord::Migration
  def up
    Function.destroy_all
    Showtime.destroy_all
    drop_table :functions_showtimes
    drop_table :showtimes
    create_table :showtimes do |t|
      t.datetime :time
      t.references :function

      t.timestamps
    end
    add_index :showtimes, :function_id
  end

  def down
    drop_table :showtimes
    create_table :showtimes do |t|
      t.datetime :time
    end
    
    create_table :functions_showtimes, id: false do |t|
      t.integer :function_id
      t.integer :showtime_id
    end
    add_index :functions_showtimes, :function_id
    add_index :functions_showtimes, :showtime_id
  end
end
