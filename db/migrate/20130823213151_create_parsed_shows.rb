class CreateParsedShows < ActiveRecord::Migration
  def change
    create_table :parsed_shows do |t|
      t.string :name
      t.integer :show_id

      t.timestamps
    end
    add_index :parsed_shows, :show_id
  end
end
