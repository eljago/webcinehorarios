class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.integer :vtr
      t.integer :directv

      t.timestamps
    end
  end
end
