class AddColorToFunctionTypes < ActiveRecord::Migration
  def change
    add_column :function_types, :color, :string
  end
end
