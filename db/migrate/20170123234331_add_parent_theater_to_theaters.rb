class AddParentTheaterToTheaters < ActiveRecord::Migration[5.0]
  def change
    add_column :theaters, :parent_theater_id, :integer
  end
end
