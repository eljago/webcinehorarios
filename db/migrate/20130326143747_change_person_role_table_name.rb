class ChangePersonRoleTableName < ActiveRecord::Migration
  def change
    rename_table :movie_person_roles, :show_person_roles
    rename_column :show_person_roles, :movie_id, :show_id
  end
end
