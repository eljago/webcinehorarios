class RevertNotNullMigration < ActiveRecord::Migration[5.0]
  def change
	change_column_null :images, :backdrop, true, false
    change_column_null :images, :poster, true, false
    change_column_null :shows, :active, true, false
    change_column_null :theaters, :active, true, false
    change_column_null :show_person_roles, :writer, true, false
    change_column_null :show_person_roles, :director, true, false
    change_column_null :show_person_roles, :actor, true, false
    change_column_null :show_person_roles, :producer, true, false
    change_column_null :show_person_roles, :creator, true, false
    change_column_null :awards, :active, true, false
    change_column_null :nominations, :winner, true, false
  end
end
