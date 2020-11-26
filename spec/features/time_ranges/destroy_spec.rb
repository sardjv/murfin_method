require 'rails_helper'

describe 'User destroys a time range', type: :feature, js: true do
  let(:current_user) { create(:user) }
  let!(:time_range) { create(:time_range, user: current_user) }

  before { log_in current_user }

  it 'destroys time range' do
    visit time_ranges_path

    accept_confirm { first('.bi-trash').click }

    expect(page).to have_content(I18n.t('notice.successfully.destroyed', model_name: TimeRange.model_name.human))
    refute(TimeRange.exists?)
  end
end
