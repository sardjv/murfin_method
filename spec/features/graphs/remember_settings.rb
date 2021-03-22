describe 'remember graph settings', js: true do
  let(:user) { create :user }
  let(:user_group) { create :user_group }

  let!(:membership) { create :membership, :lead, user_group: user_group, user: user }

  before do
    log_in user
    visit dashboard_path

    within '.navbar' do
      click_link 'Team'
    end
  end

  it 'has graph with default settings' do
    within '#chart-container' do
      expect(page).to have_css '#graph_kind_percentage_delivered[checked=checked]'
      expect(page).to have_css '#time_scope_weekly[checked=checked]'
    end
  end

  it 'remembers time scope and graph kind settings' do
    find('#graph_kind_planned_vs_actual').click
    find('#time_scope_monthly').click

    within '.nav-tabs' do
      click_link 'Individuals'
    end

    expect(page).to have_css 'canvas#bar-chart'

    within '#team-individuals-table' do
      within "tr[data-user-id = '#{user.id}']" do
        click_link 'Individual Summary'
      end
    end

    assert_graph_settings
  end

  def assert_graph_settings
    within '#chart-container' do
      expect(page).to have_css '#graph_kind_planned_vs_actual[checked=checked]'
      expect(page).to have_css '#time_scope_monthly[checked=checked]'
    end
  end
end
