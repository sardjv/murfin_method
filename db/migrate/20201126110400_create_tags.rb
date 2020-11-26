class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.references :tag_type, null: false

      t.timestamps
    end
    add_index 'tags', ['tag_type_id', 'name'], unique: true
  end
end
