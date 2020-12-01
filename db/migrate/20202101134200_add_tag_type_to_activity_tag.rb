class AddTagTypeToActivityTag < ActiveRecord::Migration[6.0]
  def change
    add_reference :activity_tags, :tag_type
  end
end
