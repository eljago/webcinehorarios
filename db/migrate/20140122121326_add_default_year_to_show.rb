class AddDefaultYearToShow < ActiveRecord::Migration
  def up
    change_column :shows, :year, :integer, default: 0, null: false
  end
  def down
    change_column :shows, :year, :integer, default: nil, null: true
    sql = "UPDATE shows SET year=NULL WHERE year = 0"
    ActiveRecord::Base.connection.execute(sql)
  end
end
