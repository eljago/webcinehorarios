class ChangeColumnRatingOnShows < ActiveRecord::Migration
  def up
    change_column :shows, :rating, :string
  end
  def down
    change_column :shows, :rating, :integer
  end
end
