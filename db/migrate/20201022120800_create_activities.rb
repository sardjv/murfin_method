class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.text :schedule, null: false, limit: 16777215 # The limit forces the column type to 16MB MediumText.
      t.references :plan, null: false

      t.timestamps
    end
  end
end
