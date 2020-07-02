require 'rails_helper'

describe 'Dashboard Individuals', type: :feature do
  let(:user) { create(:user) }

  let(:plan_id) { TimeRangeType.plan_type.id }
  let(:actual_id) { TimeRangeType.actual_type.id }
  let!(:plan_ranges) do
    create_list(
      :time_range,
      10,
      user_id: user.id,
      time_range_type_id: plan_id,
      start_time: 1.week.ago,
      end_time: Time.zone.now,
      value: 10
    )
  end
  let!(:actual_ranges) do
    create_list(
      :time_range,
      10,
      user_id: user.id,
      time_range_type_id: actual_id,
      start_time: 1.week.ago,
      end_time: Time.zone.now,
      value: 5
    )
  end

  it 'has table with planned and actual data' do
    visit individuals_dashboard_path
    expect(page).to have_text 'Percentage delivered against job plan'
    within('.table') do
      expect(page).to have_text 'Job Plan'
      expect(page).to have_text '1.9'
      expect(page).to have_text 'RIO Data'
      expect(page).to have_text '1.0'
      expect(page).to have_text 'Percentage delivered'
      expect(page).to have_text '50%'
      expect(page).to have_text 'Status'
    end
  end
end
