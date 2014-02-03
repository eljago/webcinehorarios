class CreateNominationPersonJoinTable < ActiveRecord::Migration
  def change
    create_table :nominations_people, id: false do |t|
      t.integer :nomination_id
      t.integer :person_id
    end
    add_index :nominations_people, [:nomination_id, :person_id]
  end
end
