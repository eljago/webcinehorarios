class ChangeTableNameFunctionTypes < ActiveRecord::Migration
  def change
    rename_table :function_function_types, :function_types_functions
  end
end
