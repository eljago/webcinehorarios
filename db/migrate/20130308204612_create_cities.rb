class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :image
      t.references :country

      t.timestamps
    end
      add_index :cities, :country_id
  end
end
