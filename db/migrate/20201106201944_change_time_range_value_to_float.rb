class ChangeTimeRangeValueToFloat < ActiveRecord::Migration[6.0]
  def up
    change_column :time_ranges, :value, :float, null: false
  end

  def down
    change_column :time_ranges, :value, :integer, null: false
  end
end
