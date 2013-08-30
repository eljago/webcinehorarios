class AddImdbCodeToShow < ActiveRecord::Migration
  def change
    add_column :shows, :imdb_code, :string
    add_column :shows, :imdb_score, :integer, limit: 1
  end
end
