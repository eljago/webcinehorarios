class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.string :author
      t.text :comment
      t.datetime :date
    end
  end
end
