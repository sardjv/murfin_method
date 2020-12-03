class RenameActivityTag < ActiveRecord::Migration[6.0]
  def change
    rename_table :activity_tags, :tag_associations

    remove_index :tag_associations, %i[activity_id tag_type_id tag_id]

    rename_column :tag_associations, :activity_id, :taggable_id

    add_column :tag_associations, :taggable_type, :string, null: false

    add_index :tag_associations, %i[taggable_type taggable_id tag_id], unique: true, name: 'index_tag_associations_uniqueness'
  end
end
