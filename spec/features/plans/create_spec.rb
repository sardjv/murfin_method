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
    find_field(type: 'number').set('60')

    expect { click_button I18n.t('plan.save') }.to change { Plan.count }.by(1)

    expect(page).to have_content(I18n.t('plan.notice.successfully.created'))
    expect(Plan.last.user_id).to eq(current_user.id)
    expect(Plan.last.activities.count).to eq(1)
    expect(Plan.last.end_date).to eq(Plan.last.start_date + 1.year - 1.day)
  end
end
