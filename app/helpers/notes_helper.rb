module NotesHelper
  def note_states_for_select
    Note.states.keys.index_by(&:capitalize)
  end
end
