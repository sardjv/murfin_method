class NotesController < ApplicationController
  def create
    note = Note.new(note_params)
    note.author_id = current_user.id
    note.subject_type = 'User'
    note.subject_id = current_user.id
    note.save
  end

  private

  # Only allow a trusted parameter "white list" through.
  def note_params
    params.require(:note).permit(:content, :start_time, :end_time, :subject_type, :subject_id)
  end
end
