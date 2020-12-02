class AddTagTypeToActivityTag < ActiveRecord::Migration[6.0]
  def change
    # add_reference :activity_tags, :tag_type

    # # Add tag_type_id to the unique index.
    # remove_index :activity_tags, %i[tag_id activity_id]
    # add_index :activity_tags, %i[activity_id tag_type_id tag_id], unique: true

    # # Allow null tag_id on activity.
    # change_column :activity_tags, :tag_id, :string, null: true
  end
end
