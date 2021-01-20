class AddDefaultForFilterToTag < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :default_for_filter, :boolean, default: false, null: false
  end
end
