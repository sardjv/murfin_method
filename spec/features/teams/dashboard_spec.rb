require 'rails_helper'

describe 'Team Dashboard ', type: :feature, js: true do
  let(:user) { create(:user, first_name: 'Lekisha', last_name: 'Sporer') }
  let(:manager) { create(:user, first_name: 'John', last_name: 'Smith', email: 'john@example.com') }

  let!(:user_group) { create(:user_group, name: 'CAHMS') }
  let!(:user_membership) { create(:membership, user_group: user_group, user: user) }
  let!(:lead_membership) { create(:membership, user_group: user_group, user: manager, role: 'lead') }

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

  before { log_in manager }

  it 'renders' do
    visit dashboard_team_path(user_group)
    expect(page).to have_text 'Cahms dashboard'
  end

  describe 'notes' do
    context 'when clicking a point on the graph' do
      let(:content) { 'a' }
      before do
        visit dashboard_team_path(user_group)
        click_graph
      end

      it 'renders a note form prefilled to the clicked-on date' do
        within '#modal' do
          expect(page).to have_bootstrap_select('Note type', options: %w[Info Action Resolved])
          expect(page).to have_field('Time period', type: 'date', with: '2020-01-01')
          expect(page).to have_field('Add note', type: 'textarea')
        end
      end

      context 'with valid input' do
        before do
          fill_in 'note[content]', with: content
          click_on('Add note')
          visit dashboard_team_path(user_group)
          click_graph
        end

        it 'persists the note' do
          within '#modal' do
            expect(page).to have_field('Add note', type: 'textarea', with: content)
            expect(page).to have_content("Subject: #{manager.name}")
            expect(page).to have_content("Author: #{manager.name}")
            expect(page).to have_content('Created less than 1 second ago')
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
