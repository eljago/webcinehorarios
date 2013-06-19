class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :image
      t.date :birthdate
      t.date :deathdate
      t.string :birthplace
      t.integer :height
      t.text :information

      t.timestamps
    end
  end
end
