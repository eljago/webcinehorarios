class CreateJoinTableCountriesShows < ActiveRecord::Migration[5.0]
  def change
    create_join_table :countries, :shows do |t|
      t.index :show_id
    end
  end
end
