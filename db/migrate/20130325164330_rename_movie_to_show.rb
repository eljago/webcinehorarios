class RenameMovieToShow < ActiveRecord::Migration
  def change
    rename_table :movies, :shows
  end
end
