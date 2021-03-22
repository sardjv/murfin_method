require 'rails_helper'

describe 'Dashboard page', type: :feature do
  let(:subject) { page }
  let(:user) { create :user }

  before do
    log_in user
    visit root_path
  end

  it { is_expected.to have_current_path dashboard_path }
  it { is_expected.to have_link 'Log out' }
  it { is_expected.to have_css '.nav-link.active', text: 'Dashboard' }
  it { is_expected.to have_content 'You can use this service to' }
end
