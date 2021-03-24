class AddNameIndexToApiUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :api_users, :name, unique: true
  end
end
