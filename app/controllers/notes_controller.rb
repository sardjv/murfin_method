class NotesController < ApplicationController
  def new
    @note = Note.new(note_params)

    respond_to do |format|
      format.js
    end
  end

  def create
    @note = build_note

    if @note.save!
      respond_to do |format|
        format.json { render json: @note.to_json(only: %i[id start_time end_time]), status: :created }
      end
    else
      render :new
    end
  end

  def edit
    @note = Note.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @note = Note.find(params[:id])

    if @note.update!(note_params)
      respond_to do |format|
        format.json { render json: @note.to_json(only: %i[id start_time end_time]), status: :ok }
      end
    else
      render :edit
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

  def build_note
    note = Note.new(note_params)
    note.end_time = note.start_time
    note.author_id = current_user.id
    note.subject_id = current_user.id
    note.subject_type = 'User'
    note
  end
end
