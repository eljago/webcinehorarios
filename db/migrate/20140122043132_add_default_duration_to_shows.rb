class AddDefaultDurationToShows < ActiveRecord::Migration
  def up
    change_column :shows, :duration, :integer, default: 0, null: false
  end
  def down
    change_column :shows, :duration, :integer, default: nil, null: true
    sql = "UPDATE shows SET duration=NULL WHERE duration = 0"
    ActiveRecord::Base.connection.execute(sql)
  end
end
