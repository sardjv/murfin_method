class CreateTimeRangeTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :time_range_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
