class CreateAwardTypes < ActiveRecord::Migration
  def change
    create_table :award_types do |t|
      t.string :name
    end
    add_column :awards, :award_type_id, :integer
    add_index :awards, :award_type_id
  end
end
