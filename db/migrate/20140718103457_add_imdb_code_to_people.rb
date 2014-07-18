class AddImdbCodeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :imdb_code, :string
  end
end
