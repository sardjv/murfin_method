require 'rails_helper'

describe 'Admin searches for time range', type: :feature, js: true do
  let!(:admin) { create :admin }

  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let!(:user3) { create :user }

  let(:time_range1) { create :time_range, user: user3 }
  let(:time_range2) { create :time_range, user: user2 }
  let(:time_range3) { create :time_range, user: user1 }

  let!(:tag_type1) { create :tag_type }
  let!(:tag1a) { create :tag, tag_type: tag_type1 }
  let!(:tag1b) { create :tag, tag_type: tag_type1 }

  let!(:tag_type2) { create :tag_type, parent: tag_type1 }

  let!(:tag2a) { create :tag, tag_type: tag_type2, parent: tag1a }
  let!(:tag2b) { create :tag, tag_type: tag_type2, parent: tag1a }

  before do
    time_range1.tags << [tag1b, tag2b]
    time_range2.tags << [tag1b]
    time_range3.tags << [tag1a, tag2a]

    log_in admin
    visit admin_time_ranges_path

    find_field(type: 'search').set(query)
    click_button 'Search'
  end

  describe 'find by user last name' do
    let(:query) { user3.last_name }

    it 'finds matching users' do
      within '#time-ranges-list' do
        expect(page).to have_css "tr[data-time-range-id=#{time_range1.id}]"
        expect(page).not_to have_css "tr[data-time-range-id=#{time_range2.id}]"
        expect(page).not_to have_css "tr[data-time-range-id=#{time_range3.id}]"
      end
    end
  end

  describe 'find by tag' do
    let(:query) { tag1b.name }

    it 'finds matching users' do
      within '#time-ranges-list' do
        expect(page).to have_css "tr[data-time-range-id=#{time_range1.id}]"
        expect(page).to have_css "tr[data-time-range-id=#{time_range2.id}]"
        expect(page).not_to have_css "tr[data-time-range-id=#{time_range3.id}]"
      end
    end
  end

  describe 'find by appointment id' do
    let(:query) { time_range2.appointment_id }

    it 'finds matching users' do
      within '#time-ranges-list' do
        expect(page).not_to have_css "tr[data-time-range-id=#{time_range1.id}]"
        expect(page).to have_css "tr[data-time-range-id=#{time_range2.id}]"
        expect(page).not_to have_css "tr[data-time-range-id=#{time_range3.id}]"
      end
    end
  end
end
