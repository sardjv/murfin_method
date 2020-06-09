class CreateTimeRanges < ActiveRecord::Migration[6.0]
  def change
    create_table :time_ranges do |t|
      t.timestamp :start_time, null: false
      t.timestamp :end_time, null: false
      t.integer :value, null: false
      t.references :time_range_type, null: false

      t.timestamps
    end
  end
end
