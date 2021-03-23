require 'rails_helper'

describe 'Admin creates an API User', type: :feature, js: true do
  let!(:admin) { create :admin }
  let!(:api_user) { create(:api_user) }

  before do
    log_in admin
    visit admin_api_users_path
  end

  it 'destroys API user' do
    accept_confirm do
      within "#api_user_#{api_user.id}" do
        first('.bi-trash').click
      end
    end

    expect(page).to have_content(I18n.t('notice.successfully.destroyed', model_name: ApiUser.model_name.human))
    expect(ApiUser.all.count).to eq 0
  end
end
