class CreateShowtimes < ActiveRecord::Migration
  def change
    create_table :showtimes do |t|
      t.datetime :time
      t.references :function

      t.timestamps
    end
    add_index :showtimes, :function_id
  end
end
