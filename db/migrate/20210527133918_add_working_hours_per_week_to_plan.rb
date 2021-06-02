class AddWorkingHoursPerWeekToPlan < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :working_hours_per_week, :decimal, precision: 6, scale: 2
  end
end
