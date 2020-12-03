class AddActiveAtToTagType < ActiveRecord::Migration[6.0]
  def change
    add_column :tag_types, :active_at, :datetime
  end
end
