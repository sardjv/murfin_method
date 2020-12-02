class FixActivityTagTagColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :activity_tags, :tag_id, :bigint, null: true
  end
end
