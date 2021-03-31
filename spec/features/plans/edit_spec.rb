require 'rails_helper'

describe 'User edits a plan', type: :feature, js: true do
  let(:current_user) { create :user }

  let(:tag_type1) { create :tag_type, name: 'Patient Contact' }
  let(:tag_type2) { create :tag_type, name: 'Lorem' }
  let!(:tag1a) { create :tag, name: 1, tag_type: tag_type1 }
  let!(:tag1b) { create :tag, name: 2, tag_type: tag_type1 }

  let!(:tag2a) { create :tag, tag_type: tag_type2 }
  let!(:tag2b) { create :tag, tag_type: tag_type2 }

  let(:plan) { create :plan, user: current_user }
  let!(:activity1) { create :activity, plan: plan }
  let!(:tag_association) { create :tag_association, tag_type: tag_type1, tag: tag1a, taggable: activity1 }

  let(:end_date_year) { plan.start_date.year + 2 }
  let(:success_message) { I18n.t('notice.successfully.updated', model_name: Plan.model_name.human) }

  before do
    log_in current_user
    visit plans_path
    first('.bi-pencil').click
  end

  it 'updates plan' do
    bootstrap_select_year end_date_year, from: 'End date'

    within '.patient-contact' do
      find("option[data-id='#{tag1b.id}']").click
    end
    click_button 'Save'

    expect(page).to have_content success_message
    expect(plan.reload.end_date.year).to eq end_date_year
    expect(plan.activities.first.tags.first).to eq tag1b
  end

  describe 'add activity' do
    let(:time_worked_hours) { 8 }
    let(:activity2) { plan.activities.unscoped.last }
    let(:activities_last_row_selector) { '.activities .nested-fields:last-of-type' }

    before do
      click_link 'Add Activity'
    end

    it 'adds activity to the plan' do
      within activities_last_row_selector do
        within '.lorem' do
          find("option[data-id='#{tag2a.id}']").click
        end

        within '.time-worked-per-week' do
          find_field(type: 'number', match: :first).set(time_worked_hours)
        end
      end

      expect { click_button 'Save' }.to change(plan.activities, :count).by(1)

      within activities_last_row_selector do
        within '.lorem' do
          expect(page).to have_css '.filter-option-inner-inner', text: tag2a.name
        end

        within '.time-worked-per-week' do
          expect(page).to have_css "input.duration-picker-activity[value = '#{(time_worked_hours * 3600).to_f}']", visible: false
        end
      end

      expect(activity2.seconds_per_week.to_i).to eql time_worked_hours * 3600
    end

    context 'time worked per week not set' do
      let(:time_worked_error_message) { 'Time worked per week required' }

      it 'does not add activity and keeps selected other fields' do
        within activities_last_row_selector do
          within '.patient-contact' do
            find("option[data-id='#{tag1a.id}']").click
          end

          within '.lorem' do
            find("option[data-id='#{tag2a.id}']").click
          end
        end

        expect { click_button 'Save' }.not_to change(plan.activities, :count)

        within activities_last_row_selector do
          within '.time-worked-per-week' do
            expect(page).to have_css '.error', text: time_worked_error_message
          end

          within '.patient-contact' do
            expect(page).to have_css '.filter-option-inner-inner', text: tag1a.name
          end

          within '.lorem' do
            expect(page).to have_css '.filter-option-inner-inner', text: tag2a.name
          end
        end
      end
    end
  end
  # TODO: add similar scenario for create spec

  context 'with end before start' do
    let(:end_date_year) { plan.start_date.year - 1 }

    before do
      bootstrap_select_year end_date_year, from: Plan.human_attribute_name('end_date')
    end

    it 'does not save' do
      expect { click_button 'Save' }.not_to change(Plan, :count)

      expect(page).not_to have_content success_message
    end
  end

  context 'when selecting None for tag' do
    it 'does not raise error' do
      find('#plan_activities_attributes_0_tag_associations_attributes_0_tag_id option', text: 'None', visible: false).click

      click_button 'Save'

      expect(page).to have_content success_message
    end
  end

  describe 'signoffs' do
    let(:user1) { create :user, first_name: 'Artur' } # lead of user' group
    let(:user2) { create :user, first_name: 'Barbara' } # lead of user' group
    let(:user3) { create :user, first_name: 'Anthony' } # lead but some other users' group
    let(:user4) { create :user, first_name: 'Andy' } # member of user' group
    let!(:user5) { create :user, first_name: 'Deborah' } # some user, not member of any group

    let(:user_group1) { create :user_group, users: [current_user] }
    let(:user_group2) { create :user_group }
    let(:user_group3) { create :user_group, users: [current_user] }
    let(:user_group4) { create :user_group, users: [current_user] }

    let!(:lead_membership1) { create :membership, user_group: user_group1, user: user1, role: 'lead' }
    let!(:lead_membership2) { create :membership, user_group: user_group3, user: user2, role: 'lead' }
    let!(:lead_membership3) { create :membership, user_group: user_group2, user: user3, role: 'lead' }
    let!(:member_membership1) { create :membership, user_group: user_group4, user: user4, role: 'member' }

    it "shows user group' leads ordered first in the select options" do
      within '.signoffs' do
        find('button.dropdown-toggle').click

        within '.dropdown-menu.inner.show' do
          expect('Artur').to appear_before 'Barbara'
          expect('Barbara').to appear_before 'Andy'
          expect('Andy').to appear_before 'Anthony'
          expect('Anthony').to appear_before 'Deborah'
        end
      end
    end
  end
end
