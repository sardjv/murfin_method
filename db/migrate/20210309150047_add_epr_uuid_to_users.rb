class AddEprUuidToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :epr_uuid, :string, null: false, default: ''
    add_index :users, :epr_uuid
  end
end
