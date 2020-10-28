require 'rails_helper'

describe 'User creates a plan', type: :feature, js: true do
  let(:current_user) { create(:user) }
  let(:input) { build(:plan) }

  before do
    log_in current_user
    visit plans_path
    click_link I18n.t('plan.add')
  end

  it 'creates plan for the current_user' do
    wait_for_ajax
    click_link I18n.t('activity.add')
    bootstrap_select 'Tuesday', from: I18n.t('activity.labels.day')
    bootstrap_select '09', from: I18n.t('activity.labels.start_time')
    bootstrap_select '13', from: I18n.t('activity.labels.end_time')

    expect { click_button I18n.t('plan.save') }.to change { Plan.count }.by(1)

    expect(page).to have_content(I18n.t('plan.notice.successfully.created'))
    expect(Plan.last.user_id).to eq(current_user.id)
    expect(Plan.last.activities.count).to eq(1)
    expect(Plan.last.end_date).to eq(Plan.last.start_date + 1.year - 1.day)
  end
end
