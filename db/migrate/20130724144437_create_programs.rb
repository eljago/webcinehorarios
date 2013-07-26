class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.datetime :time
      t.string :name
      t.references :channel

      t.timestamps
    end
    add_index :programs, :channel_id
  end
end
