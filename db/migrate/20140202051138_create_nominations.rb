class CreateNominations < ActiveRecord::Migration
  def change
    create_table :nominations do |t|
      t.boolean :winner
      t.integer :award_specific_nomination_id
      t.integer :show_id
      t.string :type
      t.timestamps
    end
    add_index :nominations, [:award_specific_nomination_id, :show_id]
  end
end
