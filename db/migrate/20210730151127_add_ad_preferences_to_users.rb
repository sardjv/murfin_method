class AddAdPreferencesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ad_preferences, :text
  end
end
