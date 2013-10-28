class AddSlugToTheaters < ActiveRecord::Migration
  def up
    add_column :theaters, :slug, :string
    add_index :theaters, :slug, unique: true

    add_column :cinemas, :slug, :string
    add_index :cinemas, :slug, unique: true

    add_column :countries, :slug, :string
    add_index :countries, :slug, unique: true
    
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
    
    add_column :shows, :slug, :string
    add_index :shows, :slug, unique: true
    
    add_column :genres, :slug, :string
    add_index :genres, :slug, unique: true

    add_column :cities, :slug, :string
    add_index :cities, :slug, unique: true

    add_column :people, :slug, :string
    add_index :people, :slug, unique: true

    Theater.find_each(&:save)
    Cinema.find_each(&:save)
    Country.find_each(&:save)
    Show.find_each(&:save)
    Genre.find_each(&:save)
    City.find_each(&:save)
    Person.find_each(&:save)
  end
  
  def down
    remove_index :theaters, :slug
    remove_column :theaters, :slug

    remove_index :cinemas, :slug
    remove_column :cinemas, :slug

    remove_index :countries, :slug
    remove_column :countries, :slug

    remove_index :users, :slug
    remove_column :users, :slug

    remove_index :shows, :slug
    remove_column :shows, :slug

    remove_index :genres, :slug
    remove_column :genres, :slug

    remove_index :cities, :slug
    remove_column :cities, :slug

    remove_index :people, :slug
    remove_column :people, :slug
  end
end
