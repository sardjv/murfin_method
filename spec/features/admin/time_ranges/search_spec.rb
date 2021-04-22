require 'rails_helper'

describe 'Admin searches for time range', type: :feature, js: true do
  let!(:admin) { create :admin }

  let!(:last_name) { Faker::Name.last_name }

  let!(:user1) { create :user, last_name: last_name }
  let!(:user2) { create :user }
  let!(:user3) { create :user }
  let!(:user4) { create :user, last_name: last_name }

  let(:tag_type1) { create :tag_type }
  let!(:tag1a) { create :tag, tag_type: tag_type1 }
  let!(:tag1b) { create :tag, tag_type: tag_type1 }

  let(:tag_type2) { create :tag_type, parent: tag_type1 }
  let!(:tag2aa) { create :tag, tag_type: tag_type2, parent: tag1a }
  let!(:tag2ab) { create :tag, tag_type: tag_type2, parent: tag1a }

  let!(:tag2ba) { create :tag, tag_type: tag_type2, parent: tag1b }
  let!(:tag2bb) { create :tag, tag_type: tag_type2, parent: tag1b }

  let(:time_range1) { create :time_range, user: user3, tags: [tag1a, tag2ab] }
  let(:time_range2) { create :time_range, user: user2, tags: [tag1a] }
  let(:time_range3) { create :time_range, user: user1, tags: [tag1a, tag2ab, tag1b, tag2bb] }
  let(:time_range4) { create :time_range, user: user1, tags: [tag1b, tag2ba] }

  before do
    log_in admin
    visit admin_time_ranges_path

    find_field(type: 'search').set(query)
    click_button 'Search'
  end

  describe 'find by user last name' do
    let(:query) { last_name }

    it 'finds matching users' do
      within '#time-ranges-list' do
        expect(page).to have_css "tr[data-time-range-id='#{time_range1.id}']"
        expect(page).not_to have_css "tr[data-time-range-id='#{time_range2.id}']"
        expect(page).not_to have_css "tr[data-time-range-id='#{time_range3.id}']"
        expect(page).to have_css "tr[data-time-range-id='#{time_range4.id}']"
      end
    end
  end

  describe 'find by tag' do
    let(:query) { tag2ab.name }

    it 'finds matching users' do
      within '#time-ranges-list' do
        expect(page).to have_css "tr[data-time-range-id='#{time_range1.id}']"
        expect(page).not_to have_css "tr[data-time-range-id='#{time_range2.id}']"
        expect(page).to have_css "tr[data-time-range-id='#{time_range3.id}']"
        expect(page).not_to have_css "tr[data-time-range-id='#{time_range4.id}']"
      end
    end
  end

  describe 'find by appointment id' do
    let(:query) { time_range2.appointment_id }

    it 'finds matching users' do
      within '#time-ranges-list' do
        expect(page).not_to have_css "tr[data-time-range-id='#{time_range1.id}']"
        expect(page).to have_css "tr[data-time-range-id='#{time_range2.id}']"
        expect(page).not_to have_css "tr[data-time-range-id='#{time_range3.id}']"
        expect(page).not_to have_css "tr[data-time-range-id='#{time_range4.id}']"
      end
    end
  end
end
