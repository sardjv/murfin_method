class AddGroupTypeToUserGroups < ActiveRecord::Migration[6.0]
  def change
    add_reference :user_groups, :group_type, null: false, foreign_key: true
  end
end
