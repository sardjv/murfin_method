class ChangeTimeRangeValueToDecimal < ActiveRecord::Migration[6.0]
  def up
    change_column :time_ranges, :value, :decimal, precision: 65, scale: 30, null: false
  end

  def down
    change_column :time_ranges, :value, :integer, null: false
  end
end
