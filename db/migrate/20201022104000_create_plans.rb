class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
