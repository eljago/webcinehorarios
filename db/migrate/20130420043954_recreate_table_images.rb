class RecreateTableImages < ActiveRecord::Migration
  def up
    drop_table :images
    create_table :images do |t|
      t.string :name
      t.string :image
      t.references :imageable, :polymorphic => true
      t.timestamps
    end
  end

  def down
    create_table :images do |t|
      t.string :name
      t.string :image
      t.references :imageable, :polymorphic => true
      t.timestamps
    end
    drop_table :images
  end
end
