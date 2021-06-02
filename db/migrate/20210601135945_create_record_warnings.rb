class CreateRecordWarnings < ActiveRecord::Migration[6.1]
  def change
    create_table :record_warnings do |t|
      t.integer :warnable_id
      t.string :warnable_type
      t.string :key
      t.json :data
      t.datetime :expires_at

      t.timestamps
    end
  end
end
