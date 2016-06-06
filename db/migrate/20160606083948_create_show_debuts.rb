class CreateShowDebuts < ActiveRecord::Migration
  def change
    create_table :show_debuts do |t|
      t.references :show, index: true
      t.date :debut

      t.datetime :created_at
    end
  end
end
