class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.string :name
      t.references :theater
      t.references :movie

      t.timestamps
    end
    add_index :functions, :theater_id
    add_index :functions, :movie_id
  end
end
