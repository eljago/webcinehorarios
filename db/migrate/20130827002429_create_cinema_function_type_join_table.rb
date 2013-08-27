class CreateCinemaFunctionTypeJoinTable < ActiveRecord::Migration
  def change
    create_table :cinemas_function_types, id: false do |t|
      t.integer :cinema_id
      t.integer :function_type_id
    end
  end
end
