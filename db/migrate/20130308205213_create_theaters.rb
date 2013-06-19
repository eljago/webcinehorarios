class CreateTheaters < ActiveRecord::Migration
  def change
    create_table :theaters do |t|
      t.string :name
      t.string :image
      t.string :address
      t.text :information
      t.integer :latitude
      t.integer :longitude
      t.references :cinema
      t.references :city

      t.timestamps
    end
    add_index :theaters, [:city_id, :cinema_id]
  end
end
