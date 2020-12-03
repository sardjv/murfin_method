class AddActiveForToTagType < ActiveRecord::Migration[6.0]
  def change
    add_column :tag_types, :active_for_activity_at, :datetime
    add_column :tag_types, :active_for_time_range_at, :datetime
  end
end
