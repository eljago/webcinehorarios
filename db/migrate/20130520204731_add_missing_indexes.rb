class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :function_types_functions, [:function_id, :function_type_id], name: :index_f_type_functions_on_f_id_and_f_type_id
    add_index :genres_shows, [:genre_id, :show_id]
    add_index :show_person_roles, [:person_id, :show_id]
    add_index :images, [:imageable_id, :imageable_type]
  end
end
