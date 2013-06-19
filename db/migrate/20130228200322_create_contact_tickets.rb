class CreateContactTickets < ActiveRecord::Migration
  def change
    create_table :contact_tickets do |t|
      t.string :name
      t.string :from
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
