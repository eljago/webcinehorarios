class DropTablePages < ActiveRecord::Migration
  def up
    drop_table :pages
  end

  def down
    def change
      create_table :pages do |t|
        t.string :title
        t.string :permalink
        t.text :content

        t.timestamps
      end
      add_index :pages, :permalink
    end
  end
end
