require 'rails_helper'

describe 'Home page', type: :feature do
  let(:user) { create(:user) }

  before { log_in user }

  it 'has Log out link' do
    visit root_path
    expect(page).to have_text 'Log out'
  end
end
