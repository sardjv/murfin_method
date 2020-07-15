require 'rails_helper'

describe 'Team Dashboard ', type: :feature, js: true do
  let(:user) { create(:user) }

  let(:plan_id) { TimeRangeType.plan_type.id }
  let(:actual_id) { TimeRangeType.actual_type.id }
  let!(:diagonal_graph) do
    (1..12).each do |index|
      create(
        :time_range,
        user_id: user.id,
        time_range_type_id: plan_id,
        start_time: index.months.ago,
        end_time: index.months.ago + 1.week,
        value: 12
      )
      create(
        :time_range,
        user_id: user.id,
        time_range_type_id: actual_id,
        start_time: index.months.ago,
        end_time: index.months.ago + 1.week,
        value: index
      )
    end
  end

  before { visit teams_dashboard_path }

  it 'renders' do
    expect(page).to have_text 'Team dashboard'
  end

  describe 'notes' do
    context 'when clicking a point on the graph' do
      it 'renders a note form' do
        click_graph
        expect(page).to have_selector('#modal', visible: true)
      end
    end
  end
end

def click_graph
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop do
      page.find('#line-graph').click(x: 540, y: 240)
      break if page.find('#modal', visible: false).visible?
    end
  end
end
