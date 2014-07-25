class UpdateShowPersonRolesPositions < ActiveRecord::Migration
  ShowPersonRole.all.each do |show_person_role|
    show_person_role.position = show_person_role.id
    show_person_role.save
  end
end
