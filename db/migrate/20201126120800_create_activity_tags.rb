class CreateActivityTags < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_tags do |t|
      t.references :tag, null: false
      t.references :activity, null: false

      t.timestamps
    end
    add_index 'activity_tags', ['tag_id', 'activity_id'], unique: true
  end
end
