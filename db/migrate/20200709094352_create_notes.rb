class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.text :content, null: false
      t.integer :state, null: false, default: 0

      t.timestamps
    end
  end
end
