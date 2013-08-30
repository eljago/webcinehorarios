class AddRottenTomatoesToShow < ActiveRecord::Migration
  def change
    add_column :shows, :rotten_tomatoes_url, :string
    add_column :shows, :rotten_tomatoes_score, :integer, limit: 1
  end
end
