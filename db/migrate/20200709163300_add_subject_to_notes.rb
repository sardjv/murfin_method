class AddSubjectToNotes < ActiveRecord::Migration[6.0]
  def change
    add_reference :notes, :subject, polymorphic: true
  end
end
