class AddShowtimesToFunctions < ActiveRecord::Migration[5.0]
  def change
    add_column :functions, :showtimes, :string
  end
end
