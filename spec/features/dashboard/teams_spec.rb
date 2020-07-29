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

  before :all do
    Timecop.freeze(Time.zone.local(2020, 7, 15))
  end

  after :all do
    Timecop.return
  end

  before { visit teams_dashboard_path }

  it 'renders' do
    expect(page).to have_text 'Team dashboard'
  end

  describe 'notes' do
    context 'when clicking a point on the graph' do
      before { click_graph }

      it 'renders a note form prefilled to the clicked-on date' do
        within '#modal' do
          expect(page).to have_bootstrap_select('Note type', options: %w[Info Action Resolved])
          expect(page).to have_field('Time period', type: 'date', with: '2020-01-01')
          expect(page).to have_field('Add note', type: 'textarea')
        end
      end

      context 'with valid input' do
        let(:content) { 'a' }
        let(:updated_content) { 'b' }
        before do
          fill_in 'note[content]', with: content
          wait_for_ajax
        end

        describe 'clicking add' do
          before do
            click_on('Add note')
            wait_for_ajax
          end

          it 'allows editing' do
            click_graph
            within '#modal' do
              expect(page).to have_field('Add note', type: 'textarea', with: content)
              fill_in 'note[content]', with: updated_content, fill_options: { clear: :backspace }
              wait_for_ajax
              click_on('Save')
              wait_for_ajax
            end

            click_graph
            within '#modal' do
              expect(page).to have_field('Add note', type: 'textarea', with: updated_content)
            end
          end
        end
      end
    end
  end
end

def click_graph
  sleep(1)
  page.find('#line-graph').click(x: 540, y: 240)
end
