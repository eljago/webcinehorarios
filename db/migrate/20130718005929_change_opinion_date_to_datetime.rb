class ChangeOpinionDateToDatetime < ActiveRecord::Migration
  def change
    remove_column :opinions, :date
    add_column :opinions, :date, :date
  end
end
