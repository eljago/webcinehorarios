class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.string :image
      t.text :information
      t.integer :duration
      t.string :director
      t.string :name_original
      t.string :writers
      t.integer :rating

      t.timestamps
    end
  end
end
