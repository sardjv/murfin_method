require 'rails_helper'

describe 'Admin creates an API User', type: :feature, js: true do
  let!(:admin) { create :admin }

  let(:name) { Faker::Name.first_name }
  let(:contact_email) { Faker::Internet.email }

  before do
    log_in admin
    visit admin_api_users_path
    click_link I18n.t('actions.add', model_name: ApiUser.model_name.human)
  end

  it 'creates API user' do
    fill_in ApiUser.human_attribute_name('name'), with: name
    fill_in ApiUser.human_attribute_name('contact_email'), with: contact_email
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: ApiUser.model_name.human))

    expect(ApiUser.all.count).to eq 1
    expect(ApiUser.all.first.created_by).to eq admin.name

    expect(page).to have_content("#{I18n.t('actions.generate',
                                           attribute_name: ApiUser.human_attribute_name('api_token'))} for #{ApiUser.all.first.name}")
  end
end
