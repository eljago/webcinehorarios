class RemoveWinnerShowFromAwardSpecificCategory < ActiveRecord::Migration
  def change
    remove_column :award_specific_categories, :winner_show
  end
end
