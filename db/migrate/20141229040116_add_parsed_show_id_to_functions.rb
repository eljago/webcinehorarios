class AddParsedShowIdToFunctions < ActiveRecord::Migration
  def up
    add_column :functions, :parsed_show_id, :integer
    add_index :functions, :parsed_show_id
    Show.all.each do |show|
      show.functions.all.each do |function|
        function.parsed_show_id = show.parsed_shows.first.id if show.parsed_shows.count > 0
      end
    end
  end
  def down
    remove_column :functions, :parsed_show_id
  end
end
