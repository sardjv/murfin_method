class CreateSignoffs < ActiveRecord::Migration[6.0]
  def change
    create_table :signoffs do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :signed_at
      t.datetime :revoked_at

      t.timestamps
    end
  end
end
