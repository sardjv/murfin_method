class AddNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string, null: false
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
