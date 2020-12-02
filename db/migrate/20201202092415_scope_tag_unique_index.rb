class ScopeTagUniqueIndex < ActiveRecord::Migration[6.0]
  def change
    # Scope tags to their parent (e.g. DCC), rather than tag_type (e.g. Subcategory).
    remove_index :tags, %i[tag_type_id name]
    add_index :tags, %i[parent_id name], unique: true

    # ActivityTag#tag_type_id should be null: false.
    remove_reference :activity_tags, :tag_type
    add_reference :activity_tags, :tag_type, null: false
  end
end
