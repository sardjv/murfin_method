require 'rails_helper'

describe 'User edits a plan', type: :feature, js: true do
  let(:current_user) { create :user }

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

  let(:start_date) { Date.current.beginning_of_year }
  let(:end_date) { Date.current.end_of_year }
  let(:plan) { create :plan, user: current_user, start_date: start_date, end_date: end_date }

  let!(:activity1) { create :activity, plan: plan, seconds_per_week: 4 * 3600 } # 4h
  let!(:tag_association1) { create :tag_association, tag_type: tag_type1, tag: tag1a, taggable: activity1 }
  let!(:tag_association1a) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2a, taggable: activity1 }

  let(:end_date_year) { plan.start_date.year + 2 }

  let(:working_hours_per_week) { 40 }

  let(:success_message) { I18n.t('notice.successfully.updated', model_name: Plan.model_name.human) }
  let(:error_message) { 'Job plan could not be updated' }

  before do
    log_in current_user
    visit edit_plan_path(plan)
  end

  it 'updates plan' do
    within '.category' do
      find("option[data-id='#{tag1b.id}']").click
    end

    fill_in working_hours_per_week, with: working_hours_per_week

    find('.plan-end-date-container input').click

    within '.flatpickr-calendar .flatpickr-months' do
      2.times { find('.flatpickr-next-month').click } # 2 years forward
    end

    within '.flatpickr-monthSelect-months' do
      find(:xpath, "span[text() = 'Jan']").click # Jan
    end

    click_button 'Save'

    expect(page).to have_content success_message
    expect(plan.reload.end_date.year).to eq end_date_year
    expect(plan.working_hours_per_week).to eq working_hours_per_week
    expect(plan.activities.first.tags.first).to eq tag1b
  end

  it 'contains total time worked per week' do
    within '#plan-activities-table' do
      expect(page).to have_css '#plan-total-time-worked-per-week', text: 'Total time worked per week: 4h'
    end
  end

  describe 'add activity' do
    let(:time_worked_hours) { 8 }
    let(:new_activity) { plan.activities.unscoped.last }
    let(:activities_last_row_selector) { '.activities .nested-fields:last-of-type' }

    before do
      click_link 'Add Activity'
    end

    it 'adds activity to the plan' do
      within activities_last_row_selector do
        within '.category' do
          find("option[data-id='#{tag1b.id}']").click
        end

        within '.subcategory' do
          find("option[data-id='#{tag2c.id}']").click
        end

        within '.time-worked-per-week' do
          find_field(type: 'number', match: :first).set(time_worked_hours)
        end
      end

      expect { click_button 'Save' }.to change(plan.activities, :count).by(1)

      within activities_last_row_selector do
        within '.category' do
          expect(page).to have_css '.filter-option-inner-inner', text: tag1b.name
        end

        within '.subcategory' do
          expect(page).to have_css '.filter-option-inner-inner', text: tag2c.name
        end

        within '.time-worked-per-week' do
          expect(page).to have_css "input.duration-picker-activity[value = '#{(time_worked_hours * 3600).to_f}']", visible: false
        end
      end

      expect(new_activity.seconds_per_week.to_i).to eql time_worked_hours * 3600
    end

    context 'time worked per week not set' do
      let(:time_worked_error_message) { 'Time worked per week required' }

      before do
        within activities_last_row_selector do
          within '.category' do
            find("option[data-id='#{tag1a.id}']").click
          end

          within '.subcategory' do
            find("option[data-id='#{tag2a.id}']").click
          end
        end

        expect { click_button 'Save' }.not_to change(plan.activities, :count)
      end

      it 'shows form error' do
        within activities_last_row_selector do
          within '.time-worked-per-week' do
            expect(page).to have_css '.error', text: time_worked_error_message
          end
        end
      end

      it 'keeps other fields selected' do
        within activities_last_row_selector do
          within '.time-worked-per-week' do
            expect(page).to have_css '.error', text: time_worked_error_message
          end

          within '.category' do
            expect(page).to have_css '.filter-option-inner-inner', text: tag1a.name
          end

          within '.subcategory' do
            expect(page).to have_css '.filter-option-inner-inner', text: tag2a.name
          end
        end
      end

      context 'one signoff assigned' do
        it 'should not duplicate signoff' do
          within '#plan-signoffs' do
            expect(page).to have_css '.filter-option-inner-inner', text: current_user.name, count: 1
          end
        end
      end
    end
  end
  # TODO: add similar scenario for create spec

  context 'end date before start date' do
    let(:end_date_error_details) { 'must occur after start date' }

    it 'does not update plan' do
      find('.plan-start-date-container input').click

      within '.flatpickr-monthSelect-months' do # Nov
        find(:xpath, "span[text() = 'Nov']").click
      end

      find('.plan-end-date-container input').click

      within '.flatpickr-monthSelect-months' do # Oct
        find(:xpath, "span[text() = 'Oct']").click
      end

      click_button 'Save'

      expect(page).to have_css '.alert-danger', text: error_message
      expect(page).to have_css '.plan-end-date-container .invalid-feedback', text: end_date_error_details
    end
  end

  context 'when selecting None for tag' do
    it 'does not raise error' do
      find('#plan_activities_attributes_0_tag_associations_attributes_0_tag_id option', text: 'None', visible: false).click

      click_button 'Save'

      expect(page).to have_content success_message
    end
  end

  describe 'activities totals' do
    let!(:activity3) { create :activity, plan: plan, seconds_per_week: 6 * 3600 } # 6h
    let!(:tag_association3) { create :tag_association, tag_type: tag_type1, tag: tag1b, taggable: activity3 }
    let!(:tag_association3a) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2d, taggable: activity3 }

    let!(:activity4) { create :activity, plan: plan, seconds_per_week: 4 * 3600 } # 4h
    let!(:tag_association4) { create :tag_association, tag_type: tag_type1, tag: tag1b, taggable: activity4 }
    let!(:tag_association4a) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2c, taggable: activity4 }

    let!(:activity5) { create :activity, plan: plan, seconds_per_week: 2.5 * 3600 } # 2.5h
    let!(:tag_association5) { create :tag_association, tag_type: tag_type1, tag: tag1c, taggable: activity5 }
    let!(:tag_association5a) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2e, taggable: activity5 }

    before do
      visit edit_plan_path(plan)
    end

    it 'shows total hours per week groupped by tags' do
      within '#plan-totals' do
        within ".card[data-tag-id = '#{tag1a.id}']" do
          expect(page).to have_content "Category: #{tag1a.name}"
          expect(page).to have_content '4h'

          find("button[data-target = '#collapse#{tag1a.id}']").click

          within '.collapse' do
            within "tr[data-tag-id = '#{tag2a.id}']" do
              expect(page).to have_content tag2a.name
              expect(page).to have_content '4h'
            end
          end
        end

        within ".card[data-tag-id = '#{tag1b.id}']" do
          expect(page).to have_content "Category: #{tag1b.name}"
          expect(page).to have_content '10h'

          find("button[data-target = '#collapse#{tag1b.id}']").click
        end

        within ".card[data-tag-id = '#{tag1b.id}']" do
          within '.collapse' do
            within "tr[data-tag-id = '#{tag2d.id}']" do
              expect(page).to have_content tag2d.name
              expect(page).to have_content '6h'
            end

            within "tr[data-tag-id = '#{tag2c.id}']" do
              expect(page).to have_content tag2c.name
              expect(page).to have_content '4h'
            end
          end
        end

        within ".card[data-tag-id = '#{tag1c.id}']" do
          expect(page).to have_content "Category: #{tag1c.name}"
          expect(page).to have_content '2h 30m'

          expect(page).not_to have_css '.collapse'
        end
      end
    end
  end

  describe 'signoffs' do
    let!(:user1) { create :user }
    let!(:user2) { create :user }
    let!(:user3) { create :user }

    let!(:user_group1) { create :user_group, users: [current_user, user1, user3] }
    let!(:user_group2) { create :user_group, users: [current_user, user2] }

    let(:signoffs_last_row_selector) { '.signoffs .nested-fields:last-of-type' }

    it 'change signoff' do
      visit edit_plan_path(plan)
      click_link 'Add Signoff'

      within signoffs_last_row_selector do
        bootstrap_select user2.name, from: 'User'
      end

      click_button 'Save'

      expect(plan.signoffs.pluck(:user_id)).to eql [current_user.id, user2.id]
    end
  end
end
