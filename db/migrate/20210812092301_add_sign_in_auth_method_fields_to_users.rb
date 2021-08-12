class AddSignInAuthMethodFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :current_sign_in_auth_method, :string
    add_column :users, :last_sign_in_auth_method, :string
  end
end
