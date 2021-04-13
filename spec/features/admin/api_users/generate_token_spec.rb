require 'rails_helper'

describe 'Admin generates a token for an API User', type: :feature, js: true do
  let!(:admin) { create :admin }
  let!(:api_user) { create(:api_user) }

  around do |example|
    ClimateControl.modify JWT_ALGORITHM: 'HS256', JWT_SECRET: 'my$ecretK3y' do
      example.run
    end
  end

  before do
    log_in admin
    visit admin_api_user_path(api_user)
  end

  it 'generates API Token' do
    expect(page).to have_content("#{I18n.t('actions.generate',
                                           attribute_name: ApiUser.human_attribute_name('api_token'))} for #{ApiUser.all.first.name}")
    expect(page).to have_content(I18n.t('api_users.token_description'))
    expect(page).not_to have_content(I18n.t('api_users.current_token'))
    expect(page).not_to have_content(ApiUser.human_attribute_name('generated_by'))
    expect(page).not_to have_content(ApiUser.human_attribute_name('generated_at'))
    expect(page).not_to have_content(I18n.t('api_users.token_warning'))

    click_button I18n.t('api_users.generate_new_token')
    expect(page).to have_content(I18n.t('api_users.token_notice', name: api_user.name))

    api_user.reload
    expect(api_user.token_sample).not_to be_nil
    expect(api_user.token_generated_at).not_to be_nil
    expect(api_user.token_generated_by).to eq admin.name
  end

  context 'when api user has a token' do
    let!(:api_user) do
      create(:api_user, token_sample: current_token_sample,
                        token_generated_at: current_token_generated_at,
                        token_generated_by: current_token_generated_by)
    end
    let(:current_token_sample) { '88xaE' }
    let(:current_token_generated_at) { Time.zone.parse('10:30 01/04/2021') }
    let(:current_token_generated_by) { 'Bella Owen' }

    it 'can revoke the current token and generate a new token' do
      accept_confirm do
        click_button I18n.t('api_users.revoke_and_generate_new_token')
      end
      expect(page).to have_content(I18n.t('api_users.token_notice', name: api_user.name))

      api_user.reload
      expect(api_user.token_sample).not_to eq current_token_sample
      expect(api_user.token_generated_at).not_to eq current_token_generated_at
      expect(api_user.token_generated_by).not_to eq current_token_generated_by
      expect(api_user.token_generated_by).to eq admin.name
    end
  end
end
