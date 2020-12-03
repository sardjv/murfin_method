class RenameActivityTag < ActiveRecord::Migration[6.0]
  def change
    rename_table :activity_tags, :tag_associations
  end
end
