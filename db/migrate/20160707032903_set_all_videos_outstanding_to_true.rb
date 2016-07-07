class SetAllVideosOutstandingToTrue < ActiveRecord::Migration
  def up
  	Video.update_all outstanding: true
  end
end
