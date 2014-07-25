class AddPositionToShowPersonRoles < ActiveRecord::Migration
  def change
    add_column :show_person_roles, :position, :integer
  end
end
