class CreateFunctionFunctionTypesJoinTable < ActiveRecord::Migration
  def change
    create_table :function_function_types, :id => false do |t|
      t.integer :function_id
      t.integer :function_types_id
    end
  end
end
