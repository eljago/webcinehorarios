class AddParseHelperToTheaters < ActiveRecord::Migration
  def change
    add_column :theaters, :parse_helper, :string
  end
end
