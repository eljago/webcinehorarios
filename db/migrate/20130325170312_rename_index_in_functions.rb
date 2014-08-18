class RenameIndexInFunctions < ActiveRecord::Migration
  def up
    # remove_index :functions, :movie_id
    # add_index :functions, :show_id
    # # remove_index 'functions', name: 'index_functions_on_movie_id'
    # # add_index "functions", ["show_id"], :name => "index_functions_on_show_id"
  end

  def down
    # remove_index 'functions', name: 'index_functions_on_show_id'
    # add_index "functions", ["movie_id"], :name => "index_functions_on_movie_id"
  end
end
