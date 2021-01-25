require 'rails_helper'

describe 'Admin creates a user', type: :feature, js: true do
  let!(:admin) { create :admin }
  # let(:password) { Faker::Internet.password }

  before do
    log_in admin
  end

  it 'creates user' do
    visit admin_users_path

    click_link I18n.t('actions.add', model_name: User.model_name.human.titleize)
    fill_in User.human_attribute_name('first_name'), with: 'Mary'
    fill_in User.human_attribute_name('last_name'), with: 'Anne'
    fill_in User.human_attribute_name('email'), with: 'mary@example.com'
    # fill_in User.human_attribute_name('password'), with: password
    # fill_in User.human_attribute_name('password_confirmation'), with: password
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: User.model_name.human))
    expect(User.all.count).to eq 2
  end

  it 'creates user with no password' do
    visit admin_users_path

    click_link I18n.t('actions.add', model_name: User.model_name.human.titleize)
    fill_in User.human_attribute_name('first_name'), with: 'Mary'
    fill_in User.human_attribute_name('last_name'), with: 'Anne'
    fill_in User.human_attribute_name('email'), with: 'mary@example.com'
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: User.model_name.human))
    expect(User.all.count).to eq 2
  end

  context 'when enter non unique email' do
    let(:email) { Faker::Internet.email }
    let!(:existing_user) { create :user, email: email }

    it 'does not create user' do
      visit admin_users_path

      click_link I18n.t('actions.add', model_name: User.model_name.human.titleize)
      fill_in User.human_attribute_name('first_name'), with: 'Mary'
      fill_in User.human_attribute_name('last_name'), with: 'Anne'
      fill_in User.human_attribute_name('email'), with: email
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: User.model_name.human))
      expect(User.all.count).to eq 2
    end
  end

  xcontext 'password does not match confirmation' do
    let!(:existing_user) { create(:user, email: 'john@example.com') }

    it 'does not create user' do
      visit admin_users_path

      click_link I18n.t('actions.add', model_name: User.model_name.human.titleize)
      fill_in User.human_attribute_name('first_name'), with: 'Mary'
      fill_in User.human_attribute_name('last_name'), with: 'Anne'
      fill_in User.human_attribute_name('email'), with: 'john@example.com'
      fill_in User.human_attribute_name('password'), with: password
      fill_in User.human_attribute_name('password_confirmation'), with: "#{password}$"
      click_button I18n.t('actions.save')

      within_invalid_form_field 'user_password_confirmation' do
        expect(page).to have_content "doesn't match Password"
      end
    end
  end
end
