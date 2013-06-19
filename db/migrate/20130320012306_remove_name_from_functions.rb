class RemoveNameFromFunctions < ActiveRecord::Migration
  def up
    remove_column :functions, :name
  end

  def down
    add_column :functions, :name, :string
  end
end
