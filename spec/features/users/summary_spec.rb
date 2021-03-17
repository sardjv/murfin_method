require 'rails_helper'

describe 'User Summary', type: :feature, js: true do
  let(:actual_id) { TimeRangeType.actual_type.id }
  let(:user) { create :user }

  let!(:user_group_team) { create :user_group, :team }
  let!(:user_group_band) { create :user_group, :band }

  let!(:user_team_membership) { create :membership, user_group: user_group_team, user: user, role: 'member' }
  let!(:user_band_membership) { create :membership, user_group: user_group_band, user: user, role: 'member' }

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
    log_in user
    visit dashboard_path
    within '.nav-tabs' do
      click_link 'Summary'
    end
  end

  it { expect(current_path).to eql users_summary_path }
  it { expect(page).to have_css 'a.nav-link.active', text: 'Summary' }

  it 'shows chart with default options selected' do
    within '#team-individual-chart-container' do
      expect(page).to have_css '#graph_kind_percentage_delivered[checked=checked]'
      expect(page).to have_css '#time_scope_weekly[checked=checked]'

      expect(page).to have_css 'canvas#line-graph'
    end
  end
end
