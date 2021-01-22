require 'rails_helper'

describe 'Admin Dashboard', type: :feature do
  let(:user) { create(:user) }
  let!(:plan) do
    create(
      :plan,
      user_id: user.id,
      start_date: 1.week.ago,
      end_date: Time.current,
      activities: [create(:activity, seconds_per_week: 6000)]
    )
  end
  let!(:actual_ranges) do
    create_list(
      :time_range,
      10,
      user_id: user.id,
      time_range_type_id: TimeRangeType.actual_type.id,
      start_time: 1.week.ago,
      end_time: Time.current,
      value: 5
    )
  end

  before { log_in create(:admin) }

  it 'has graph with planned and actual data' do
    visit admin_dashboard_path
    expect(page).to have_text 'Percentage delivered against job plan'
  end
end
