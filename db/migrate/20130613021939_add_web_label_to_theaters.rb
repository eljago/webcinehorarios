class AddWebLabelToTheaters < ActiveRecord::Migration
  def change
    add_column :theaters, :web_label, :string
  end
end
