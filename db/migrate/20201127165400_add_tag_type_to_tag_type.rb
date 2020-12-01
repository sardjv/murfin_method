class AddTagTypeToTagType < ActiveRecord::Migration[6.0]
  def change
    add_reference :tag_types, :parent
  end
end
