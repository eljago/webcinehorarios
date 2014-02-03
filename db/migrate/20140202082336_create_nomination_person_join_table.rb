class CreateNominationPersonJoinTable < ActiveRecord::Migration
  def change
    create_table :nomination_person_roles do |t|
      t.integer :nomination_id
      t.integer :person_id
    end
    add_index :nomination_person_roles, [:nomination_id, :person_id]
  end
end
