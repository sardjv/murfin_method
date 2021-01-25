require 'rails_helper'

describe 'Admin edits a user', type: :feature, js: true do
  let!(:admin) { create :admin }

  let(:first_name) { Faker::Name.first_name }
  let(:new_first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }
  let!(:user) { create :user, first_name: first_name, last_name: last_name, email: email }

  let(:password) { Faker::Internet.password }

  before do
    log_in admin
    visit admin_users_path
    first('.bi-pencil').click
  end

  it 'updates user' do
    fill_in User.human_attribute_name('first_name'), with: new_first_name
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: User.model_name.human))
    expect(user.reload.first_name).to eq new_first_name
  end

  xit 'updates user password' do # TODO: enable when ENV issues on tests resolved
    fill_in User.human_attribute_name('password'), with: password
    fill_in User.human_attribute_name('password_confirmation'), with: password
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: User.model_name.human))
  end

  context 'when enter non unique email' do
    let(:new_email) { Faker::Internet.email }
    let!(:existing_user) { create :user, email: new_email }

    it 'does not update user' do
      fill_in User.human_attribute_name('email'), with: new_email
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.updated', model_name: User.model_name.human))
      expect(user.reload.email).to eq email
    end
  end

  xcontext 'password is too short' do # TODO: enable when ENV issues on tests resolved
    let(:password) { '123' }

    it 'shows form error' do
      fill_in User.human_attribute_name('password'), with: password
      fill_in User.human_attribute_name('password_confirmation'), with: password
      click_button I18n.t('actions.save')

      within_invalid_form_field 'user_password' do
        expect(page).to have_content 'is too short (minimum is 6 characters)'
      end
    end
  end
end
