require 'rails_helper'

describe 'Admin edits a user', type: :feature, js: true do
  let!(:user) do
    create(:user, first_name: 'Jo',
                  last_name: 'Anne',
                  email: 'joanne@example.com')
  end

  before { log_in create(:admin) }

  it 'updates user' do
    visit admin_users_path

    first('.bi-pencil').click
    fill_in User.human_attribute_name('first_name'), with: 'Joanne'
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: User.model_name.human))
    expect(user.reload.first_name).to eq 'Joanne'
  end

  context 'when enter non unique email' do
    let!(:existing_user) { create(:user, email: 'john@example.com') }

    it 'does not update user' do
      visit admin_users_path

      first('.bi-pencil').click
      fill_in User.human_attribute_name('email'), with: 'john@example.com'
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.updated', model_name: User.model_name.human))
      expect(user.reload.email).to eq 'joanne@example.com'
    end
  end
end
