require 'rails_helper'

describe 'Admin searches for plan', type: :feature, js: true do
  let!(:admin) { create :admin }

  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }
  let(:user4) { create :user }

  let(:tag_type1) { create :tag_type }
  let!(:tag1a) { create :tag, tag_type: tag_type1 }
  let!(:tag1b) { create :tag, tag_type: tag_type1 }

  let(:tag_type2) { create :tag_type, parent: tag_type1 }
  let!(:tag2aa) { create :tag, tag_type: tag_type2, parent: tag1a }
  let!(:tag2ab) { create :tag, tag_type: tag_type2, parent: tag1a }

  let!(:tag2ba) { create :tag, tag_type: tag_type2, parent: tag1b }
  let!(:tag2bb) { create :tag, tag_type: tag_type2, parent: tag1b }
  let!(:tag2bc) { create :tag, tag_type: tag_type2, parent: tag1b }

  let(:plan1) { create :plan, user: user1 }
  let!(:activity1a) { create :activity, plan: plan1, tags: [tag1a, tag2aa] }
  let!(:activity1b) { create :activity, plan: plan1, tags: [tag1b] }

  let(:plan2) { create :plan, user: user2 }
  let!(:activity2a) { create :activity, plan: plan2, tags: [tag1a, tag2ab] }

  let(:plan3) { create :plan, user: user3 }

  let(:plan4) { create :plan, user: user4 }
  let!(:activity4a) { create :activity, plan: plan3, tags: [tag1b, tag2bc] }
  let!(:activity4b) { create :activity, plan: plan4, tags: [tag1a, tag2aa] }

  before do
    log_in admin
    visit admin_plans_path

    find_field(type: 'search').set(query)
    click_button 'Search'
  end

  describe 'find by user email' do
    let(:query) { user2.email }

    it 'finds matching plans' do
      within '#plans-list' do
        expect(page).not_to have_css "tr[data-plan-id='#{plan1.id}']"
        expect(page).to have_css "tr[data-plan-id='#{plan2.id}']"
        expect(page).not_to have_css "tr[data-plan-id='#{plan3.id}']"
        expect(page).not_to have_css "tr[data-plan-id='#{plan4.id}']"
      end
    end
  end

  describe 'find by tag' do
    let(:query) { tag2aa.name }

    it 'finds matching plans' do
      within '#plans-list' do
        expect(page).to have_css "tr[data-plan-id='#{plan1.id}']"
        expect(page).not_to have_css "tr[data-plan-id='#{plan2.id}']"
        expect(page).not_to have_css "tr[data-plan-id='#{plan3.id}']"
        expect(page).to have_css "tr[data-plan-id='#{plan4.id}']"
      end
    end
  end
end
