class AddDefaultScoresToShow < ActiveRecord::Migration
  def change
    change_column :shows, :imdb_score, :integer, default: 0, null: false
    change_column :shows, :metacritic_score, :integer, default: 0, null: false
    change_column :shows, :rotten_tomatoes_score, :integer, default: 0, null: false
  end
end
