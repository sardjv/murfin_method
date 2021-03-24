class CreateApiUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :api_users do |t|
      t.string :name, null: false
      t.string :contact_email
      t.string :created_by
      t.string :token_generated_by
      t.string :token_sample
      t.timestamp :token_generated_at

      t.timestamps
    end
  end
end
