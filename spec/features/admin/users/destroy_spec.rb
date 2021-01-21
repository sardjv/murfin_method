require 'rails_helper'

describe 'Admin destroys a user', type: :feature, js: true do
  let!(:user) { create :user }

  before { log_in create(:admin) }

  it 'destroys user' do
    visit admin_users_path

    accept_confirm do
      first('.bi-trash').click
    end

    expect(page).to have_content(I18n.t('notice.successfully.destroyed', model_name: User.model_name.human))
    expect(User.all.count).to eq 1
  end
end
