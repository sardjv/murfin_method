class CreateMembership < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.integer :role, null: false, default: 0
      t.references :user_group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index 'memberships', ['user_group_id', 'user_id'], unique: true
  end
end
