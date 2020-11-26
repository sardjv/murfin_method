class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.text :content, null: false
      t.references :taggable, polymorphic: true

      t.timestamps
    end
  end
end
