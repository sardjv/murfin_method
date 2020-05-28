class CreateApiTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :api_tokens do |t|
      t.string :name
      t.string :content

      t.timestamps
    end
  end
end
