class AddCharacterToShowPersonRole < ActiveRecord::Migration
  def change
    add_column :show_person_roles, :character, :string
  end
end
