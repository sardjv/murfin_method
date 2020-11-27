class AddTagToTag < ActiveRecord::Migration[6.0]
  def change
    add_reference :tags, :parent
  end
end
