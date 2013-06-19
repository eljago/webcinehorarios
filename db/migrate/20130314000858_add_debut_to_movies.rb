class AddDebutToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :debut, :date
  end
end
