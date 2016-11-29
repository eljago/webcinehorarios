class SetImagePosterBackdropNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :images, :backdrop, false, false
    change_column_null :images, :poster, false, false
    change_column_null :shows, :active, false, false
    change_column_null :theaters, :active, false, false
    change_column_null :show_person_roles, :writer, false, false
    change_column_null :show_person_roles, :director, false, false
    change_column_null :show_person_roles, :actor, false, false
    change_column_null :show_person_roles, :producer, false, false
    change_column_null :show_person_roles, :creator, false, false
    change_column_null :awards, :active, false, false
    change_column_null :nominations, :winner, false, false
  end
end
