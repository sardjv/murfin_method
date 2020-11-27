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
    click_link I18n.t('actions.remove', model_name: Activity.model_name.human)
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: Plan.model_name.human))
    expect(plan.reload.end_date.year).to eq input
    expect(plan.activities.count).to eq 0
  end

  context 'with end before start' do
    let(:input) { plan.start_date.year - 1 }

    before do
      bootstrap_select input, from: I18n.t('plan.labels.end_date')
    end

    it 'does not save' do
      expect { click_button I18n.t('actions.save') }.not_to change(Plan, :count)

      expect(page).to have_content(I18n.t('notice.could_not_be.updated', model_name: Plan.model_name.human))
    end
  end
end
