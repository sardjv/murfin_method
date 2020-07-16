module NotesHelper
  def note_states_for_select
    Note.states.transform_keys(&:capitalize)
  end
end
