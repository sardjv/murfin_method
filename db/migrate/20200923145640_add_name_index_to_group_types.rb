class AddNameIndexToGroupTypes < ActiveRecord::Migration[6.0]
  def change
    add_index :group_types, :name, unique: true
  end
end
