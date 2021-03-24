require 'rails_helper'

describe 'Team Individual Summary', type: :feature, js: true do
  let(:actual_id) { TimeRangeType.actual_type.id }

  let(:manager) { create :user }
  let(:user) { create :user }

  let(:user_group) { create :user_group }

  let!(:lead_membership) { create :membership, user_group: user_group, user: manager, role: 'lead' }
  let!(:user_membership) { create :membership, user_group: user_group, user: user, role: 'member' }

  let(:plan_start_date) { (1.week.ago + 1.day).to_date }
  let(:plan_end_date) { Date.current }
  let!(:plan) do
    create :plan, user: user,
                  start_date: plan_start_date, end_date: plan_end_date,
                  activities: [create(:activity)] # 4h per week
  end

  let!(:time_range) do
    create :time_range, user: user, time_range_type_id: actual_id,
                        start_time: plan_start_date.beginning_of_day, end_time: plan_end_date.end_of_day,
                        value: 60 # 1h in 1 week
  end

  before do
    log_in manager
    visit individuals_team_path(user_group)

    within '#team-individuals-table' do
      within "tr[data-user-id='#{user.id}']" do
        click_link 'Individual Summary'
      end
    end
  end

  it { expect(current_path).to eql team_individual_path(user_group, user) }

  it 'has active summary tab' do
    expect(page).to have_css 'a.nav-link.active', text: 'Summary'
  end

  it 'contains user group name' do
    within '#team-individual-user-groups' do
      expect(page).to have_content user_group.name
    end
  end

  it 'shows chart with default options selected' do
    within '#chart-container' do
      expect(page).to have_css '#graph_kind_percentage_delivered[checked=checked]'
      expect(page).to have_css '#time_scope_weekly[checked=checked]'

      expect(page).to have_css 'canvas#line-graph'
    end
  end
end
