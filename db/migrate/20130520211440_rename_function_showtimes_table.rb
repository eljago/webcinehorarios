class RenameFunctionShowtimesTable < ActiveRecord::Migration
  def change
    rename_table :function_showtimes, :functions_showtimes
  end
end
