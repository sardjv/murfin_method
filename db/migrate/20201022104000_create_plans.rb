class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.timestamp :start_time, null: false
      t.timestamp :end_time, null: false

      t.timestamps
    end
  end
end
