class AddActiveForToTagType < ActiveRecord::Migration[6.0]
  def change
    add_column :tag_types, :active_for_activities_at, :datetime
    add_column :tag_types, :active_for_time_ranges_at, :datetime
  end
end
