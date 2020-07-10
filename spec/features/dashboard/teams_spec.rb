require 'rails_helper'

describe 'Team Dashboard ', type: :feature do
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

  it 'renders' do
    visit teams_dashboard_path
    expect(page).to have_text 'Team dashboard'
  end

  describe 'notes' do
    context 'when clicking a point on the graph' do
      it 'renders a note form' do
      end
    end
  end
end
