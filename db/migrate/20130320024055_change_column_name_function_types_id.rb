class ChangeColumnNameFunctionTypesId < ActiveRecord::Migration
  def change
    rename_column :function_types_functions, :function_types_id, :function_type_id
  end
end
