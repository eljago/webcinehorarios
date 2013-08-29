class AddMetacriticScoreToShows < ActiveRecord::Migration
  def change
    add_column :shows, :metacritic_score, :integer, limit: 1
  end
end
