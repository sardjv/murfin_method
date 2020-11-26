class CreateTagTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_types do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index 'tag_types', 'name', unique: true
  end
end
