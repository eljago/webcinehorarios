class CreateAwardSpecificNominations < ActiveRecord::Migration
  def change
    create_table :award_specific_categories do |t|
      t.string :name
      t.integer :winner_show
      t.integer :award_id
      t.integer :award_category_id

      t.timestamps
    end
    add_index :award_specific_categories, [:award_id, :award_category_id], name: :award_s_categories
  end
end