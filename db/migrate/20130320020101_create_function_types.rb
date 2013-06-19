class CreateFunctionTypes < ActiveRecord::Migration
  def change
    create_table :function_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
