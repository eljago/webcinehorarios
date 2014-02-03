class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name
      t.boolean :active
      t.date :date
      t.string :image
      t.string :image_tmp
    end
  end
end
