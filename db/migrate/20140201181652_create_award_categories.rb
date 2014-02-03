class CreateAwardCategories < ActiveRecord::Migration
  def change
    create_table :award_categories do |t|
      t.string :name
    end
  end
end
