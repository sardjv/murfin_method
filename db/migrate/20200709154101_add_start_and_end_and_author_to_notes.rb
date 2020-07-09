class AddStartAndEndAndAuthorToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :start_time, :timestamp, null: false
    add_column :notes, :end_time, :timestamp, null: false
    add_reference :notes, :author, references: :users
  end
end
