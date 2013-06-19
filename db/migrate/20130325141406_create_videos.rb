class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :url
      t.belongs_to :videoable, polymorphic: true

      t.timestamps
    end
    add_index :videos, [:videoable_id, :videoable_type]
  end
end
