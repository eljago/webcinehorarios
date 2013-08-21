class CreateParseDetectorTypes < ActiveRecord::Migration
  def change
    create_table :parse_detector_types do |t|
      t.string :name
      t.integer :function_type_id
      t.integer :cinema_id
    end
    add_index :parse_detector_types, :function_type_id
    add_index :parse_detector_types, :cinema_id
  end
end
