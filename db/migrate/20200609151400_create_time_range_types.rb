class CreateTimeRangeTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :time_range_types do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index 'time_range_types', ['name'], :unique => true
  end
end
