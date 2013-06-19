class CreateMoviePersonRoles < ActiveRecord::Migration
  def change
    create_table :movie_person_roles do |t|
      t.integer :person_id
      t.integer :movie_id
      t.boolean :actor
      t.boolean :writer
      t.boolean :creator
      t.boolean :producer
      t.boolean :director
      t.timestamps
    end
    
    remove_column :shows, :director
    remove_column :shows, :writers
  end
end
