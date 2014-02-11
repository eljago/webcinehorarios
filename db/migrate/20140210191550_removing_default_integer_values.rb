class RemovingDefaultIntegerValues < ActiveRecord::Migration
  def up
    change_column :shows, :imdb_score, :integer, default: nil, null: true
    change_column :shows, :metacritic_score, :integer, default: nil, null: true
    change_column :shows, :rotten_tomatoes_score, :integer, default: nil, null: true
    change_column :shows, :year, :integer, default: nil, null: true
    change_column :shows, :duration, :integer, default: nil, null: true
    sql = "UPDATE shows SET duration=NULL WHERE duration = 0"
    ActiveRecord::Base.connection.execute(sql)
    sql = "UPDATE shows SET year=NULL WHERE year = 0"
    ActiveRecord::Base.connection.execute(sql)
    sql = "UPDATE shows SET imdb_score=NULL WHERE imdb_score = 0"
    ActiveRecord::Base.connection.execute(sql)
    sql = "UPDATE shows SET metacritic_score=NULL WHERE metacritic_score = 0"
    ActiveRecord::Base.connection.execute(sql)
    sql = "UPDATE shows SET rotten_tomatoes_score=NULL WHERE rotten_tomatoes_score = 0"
    ActiveRecord::Base.connection.execute(sql)
  end
  def down
    change_column :shows, :imdb_score, :integer, default: 0, null: false
    change_column :shows, :metacritic_score, :integer, default: 0, null: false
    change_column :shows, :rotten_tomatoes_score, :integer, default: 0, null: false
    change_column :shows, :year, :integer, default: 0, null: false
    change_column :shows, :duration, :integer, default: 0, null: false
  end
end
