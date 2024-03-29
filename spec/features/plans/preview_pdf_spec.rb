require 'rails_helper'

describe 'User previews job plan pdf', type: :feature, js: true do
  let(:user) { create :user }

  let!(:tag_type1) { create :tag_type, name: 'Category' }
  let!(:tag1a) { create :tag, tag_type: tag_type1 }
  let!(:tag1b) { create :tag, tag_type: tag_type1 }
  let!(:tag1c) { create :tag, tag_type: tag_type1 }

  let!(:tag_type2) { create :tag_type, name: 'Subcategory', parent: tag_type1 }
  let!(:tag2a) { create :tag, tag_type: tag_type2, parent: tag1a }
  let!(:tag2b) { create :tag, tag_type: tag_type2, parent: tag1a }

  let!(:tag2c) { create :tag, tag_type: tag_type2, parent: tag1b }
  let!(:tag2d) { create :tag, tag_type: tag_type2, parent: tag1b }
  let!(:tag2e) { create :tag, tag_type: tag_type2, parent: tag1b }

  let!(:tag_type3) { create :tag_type, name: 'Outcomed on RiO', parent: nil }
  let!(:tag3a) { create :tag, tag_type: tag_type3, parent: nil }
  let!(:tag3b) { create :tag, tag_type: tag_type3, parent: nil }

  let(:start_date) { '2020-01-01' }
  let(:end_date) { '2020-12-31' }
  let!(:plan) { create :plan, user_id: user.id, start_date: start_date, end_date: end_date, contracted_minutes_per_week: 37.5 * 60 }

  let!(:activity1) { create :activity, plan: plan, seconds_per_week: 8 * 3600 } # 8h
  let!(:tag_association1a) { create :tag_association, tag_type: tag_type1, tag: tag1a, taggable: activity1 }
  let!(:tag_association1b) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2a, taggable: activity1 }
  let!(:tag_association1c) { create :tag_association, tag_type: tag_type3, tag: tag3b, taggable: activity1 }

  let!(:activity2) { create :activity, plan: plan, seconds_per_week: 6 * 3600 } # 6h
  let!(:tag_association2a) { create :tag_association, tag_type: tag_type1, tag: tag1b, taggable: activity2 }
  let!(:tag_association2b) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2b, taggable: activity2 }

  before do
    log_in user
    visit download_plan_path(plan, layout: 'pdf')
  end

  it 'contains plan info' do
    expect(page).to have_content plan.name
    expect(page).to have_content 'Start date: January 01, 2020'
    expect(page).to have_content 'End date: December 31, 2020'
    expect(page).to have_content 'Contracted hours per week: 37h 30m'
    expect(page).to have_content 'State: Draft'
  end

  it 'contains plan activities' do
    within '#plan-activities-list' do
      within '.activities .nested-fields:first-of-type' do
        within '.category' do
          expect(page).to have_content tag1a.name
        end

        within '.subcategory' do
          expect(page).to have_content tag2a.name
        end

        within '.outcomed-on-rio' do
          expect(page).to have_content tag3b.name
        end

        within '.time-worked-per-week' do
          expect(page).to have_content '8h'
        end
      end

      within '.activities .nested-fields:last-of-type' do
        within '.category' do
          expect(page).to have_content tag1b.name
        end

        within '.subcategory' do
          expect(page).to have_content tag2b.name
        end

        expect(page).to have_selector '.outcomed-on-rio:empty'

        within '.time-worked-per-week' do
          expect(page).to have_content '6h'
        end
      end

      expect(page).to have_css '#plan-total-time-worked-per-week', text: 'Total time worked per week: 14h'
    end
  end

  describe 'signoffs' do
    let!(:signoff1) { create :signoff, user_id: user.id, plan_id: plan.id }

    let(:other_user) { create :user }
    let!(:signoff2) { create :signoff, :signed, user_id: other_user.id, plan_id: plan.id }

    it 'contains signoffs info' do
      visit download_plan_path(plan, layout: 'pdf')

      within '#plan-signoffs' do
        within "tr[data-signoff-id='#{signoff1.id}']" do
          expect(page).to have_content user.name
          expect(page).to have_content 'Unsigned'
        end

        within "tr[data-signoff-id='#{signoff2.id}']" do
          expect(page).to have_content other_user.name
          expect(page).to have_content "Signed at #{I18n.l signoff2.signed_at, format: :short}"
        end
      end
    end
  end
end
