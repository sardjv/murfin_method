class AddAppointmentIdToTimeRange < ActiveRecord::Migration[6.1]
  def change
    add_column :time_ranges, :appointment_id, :string
    add_index :time_ranges, :appointment_id, unique: true
  end
end
