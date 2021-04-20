require 'rails_helper'

describe 'User downloads plan', type: :feature do
  let(:user) { create :user }
  let!(:plan) { create :plan, user: user }

  before do
    log_in user
  end

  it 'contains plan data' do
    visit download_plan_path(plan, layout: 'pdf')

    expect(page).to have_content "User: #{user.name}"
  end
end
