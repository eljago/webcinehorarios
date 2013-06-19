class RenameStuff < ActiveRecord::Migration
  def change
    rename_table :genres_movies, :genres_shows
    rename_column :genres_shows, :movie_id, :show_id
    rename_column :functions, :movie_id, :show_id
  end
end
