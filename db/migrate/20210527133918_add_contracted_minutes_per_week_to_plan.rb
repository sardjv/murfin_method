class AddContractedMinutesPerWeekToPlan < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :contracted_minutes_per_week, :integer
  end
end
