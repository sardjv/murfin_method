require 'rails_helper'

describe 'User destroys a plan', type: :feature, js: true do
  let(:current_user) { create(:user) }
  let!(:plan) { create(:plan, user: current_user) }

  before { log_in current_user }

  it 'destroys plan' do
    visit plans_path

    accept_confirm { first('.bi-trash').click }

    expect(page).to have_content(I18n.t('notice.successfully.destroyed', model_name: Plan.model_name.human))
    refute(Plan.exists?)
  end
end
