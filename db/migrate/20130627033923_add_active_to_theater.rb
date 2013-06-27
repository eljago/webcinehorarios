class AddActiveToTheater < ActiveRecord::Migration
  def up
    add_column :theaters, :active, :boolean
    
    Theater.all.each do |theater|
      theater.active = true
      theater.save
    end
  end
  
  def down
    remove_column :theaters, :active
  end
end
