class AddNameIndexToUserGroups < ActiveRecord::Migration[6.0]
  def change
    add_index :user_groups, [:name, :group_type_id], unique: true
  end
end
