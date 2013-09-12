class RemovePersonColumns < ActiveRecord::Migration
  def up
    remove_column :people, :birthdate
    remove_column :people, :deathdate
    remove_column :people, :birthplace
    remove_column :people, :height
    remove_column :people, :information
  end

  def down
    add_column :people, :birthdate, :date
    add_column :people, :deathdate, :date
    add_column :people, :birthplace, :string
    add_column :people, :height, :integer
    add_column :people, :information, :text
  end
end