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
    bootstrap_select 'Weekly on Tuesdays', from: I18n.t('activity.labels.schedule')

    expect { click_button I18n.t('plan.save') }.to change { Plan.count }.by(1)

    expect(Plan.last.user_id).to eq(current_user.id)
    expect(Plan.last.activities.count).to eq(1)
    expect(page).to have_content(I18n.t('plan.notice.successfully.created'))
  end

  context 'with end before start' do
    before do
      bootstrap_select input.start_time.year - 2, from: I18n.t('plan.labels.end_time')
    end

    it 'does not save' do
      expect { click_button I18n.t('plan.save') }.not_to change(Plan, :count)

      expect(page).to have_content(I18n.t('plan.notice.could_not_be.created'))
    end
  end
end
