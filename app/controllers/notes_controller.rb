class NotesController < ApplicationController
  def new
    @note = Note.new(note_params)

    respond_to do |format|
      format.js
    end
  end

  def create
    note = Note.new(note_params)
    note.end_time = note.start_time
    note.author_id = current_user.id
    note.subject_id = current_user.id
    note.subject_type = 'User'

    if note.save!
      respond_to do |format|
        format.js
      end
    else
      render :new
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def note_params
    params.require(:note).permit(
      :content,
      :end_time,
      :start_time,
      :state,
      :subject_id,
      :subject_type
    )
  end
end
