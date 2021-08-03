class AddLdapToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ldap, :text
  end
end
