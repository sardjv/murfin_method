require 'rails_helper'

describe NotesHelper do
  it {
    expect(helper.note_states_for_select).to eq(
      {
        'Info' => 'info',
        'Action' => 'action',
        'Resolved' => 'resolved'
      }
    )
  }
end
