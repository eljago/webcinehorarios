class AddMetacriticUrlToShow < ActiveRecord::Migration
  def change
    add_column :shows, :metacritic_url, :string
  end
end
