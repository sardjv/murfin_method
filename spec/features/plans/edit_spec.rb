require 'rails_helper'

describe 'User edits a plan', type: :feature, js: true do
  let(:current_user) { create(:user) }
  let!(:plan) { create(:plan, user: current_user, activities: [create(:activity)]) }
  let(:input) { plan.start_date.year + 2 }

  before do
    log_in current_user
    visit plans_path
    first('.bi-pencil').click
  end

  it 'updates plan' do
    bootstrap_select input, from: I18n.t('plan.labels.end_date')
    bootstrap_select 'Tuesday', from: I18n.t('activity.labels.day')
    click_button I18n.t('plan.save')

    expect(page).to have_content(I18n.t('plan.notice.successfully.updated'))
    expect(page).to have_bootstrap_select(I18n.t('activity.labels.day'), selected: 'Tuesday')
    expect(plan.reload.end_date.year).to eq input

    click_link I18n.t('activity.remove')
    click_button I18n.t('plan.save')
    expect(page).to have_content(I18n.t('plan.notice.successfully.updated'))
    expect(plan.activities.count).to eq 0
  end

  context 'with end before start' do
    let(:input) { plan.start_date.year - 1 }

    before do
      bootstrap_select input, from: I18n.t('plan.labels.end_date')
    end

    it 'does not save' do
      expect { click_button I18n.t('plan.save') }.not_to change(Plan, :count)

      expect(page).to have_content(I18n.t('plan.notice.could_not_be.updated'))
    end
  end
end
