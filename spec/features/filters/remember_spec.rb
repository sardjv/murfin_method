describe 'filters remember', js: true do
  let(:user) { create :user }
  let(:user_group) { create :user_group }

  let!(:membership) { create :membership, :lead, user_group: user_group, user: user }

  let(:filter_last_6_months_label) { 'Last 6 months' }
  let(:filter_last_12_months_label) { 'Last 12 months' }

  let(:tag_type1) { create :tag_type }
  let(:tag_type2) { create :tag_type }

  let!(:tag1a) { create :tag, tag_type: tag_type1, default_for_filter: true }
  let!(:tag1b) { create :tag, tag_type: tag_type1, default_for_filter: false }
  let!(:tag2a) { create :tag, tag_type: tag_type2, default_for_filter: false }
  let!(:tag2b) { create :tag, tag_type: tag_type2, default_for_filter: false }
  let!(:tag2c) { create :tag, tag_type: tag_type2, default_for_filter: true }

  before do
    log_in user
    visit dashboard_path

    within '.navbar' do
      click_link 'Team'
    end
  end

  it 'remembers selected filter values' do
    within '#filters-form' do
      within '.filters-tags-container' do
        within '.select2-selection' do
          within :xpath, "//li[@title = '#{tag1a.name}']" do
            click_button 'Remove item'
          end
        end
      end

      find('#filters-predefined-ranges-toggle').click

      within '#filters-predefined-ranges-menu' do
        click_link filter_last_6_months_label
      end

      click_button 'Filter'
    end

    within '.nav-tabs' do
      click_link 'Individuals'
    end

    assert_filters_set

    within '#team-individuals-table' do
      within "tr[data-user-id = '#{user.id}']" do
        click_link 'Individual Summary'
      end
    end

    assert_filters_set

    within '.nav-tabs' do
      click_link 'Data'
    end

    assert_filters_set
  end

  describe 'reset filters' do
    before do
      within '#filters-form' do
        within '.filters-tags-container' do
          within '.select2-selection' do
            within :xpath, "//li[@title = '#{tag1a.name}']" do
              click_button 'Remove item'
            end
          end
        end

        find('#filters-predefined-ranges-toggle').click

        within '#filters-predefined-ranges-menu' do
          click_link filter_last_6_months_label
        end

        click_button 'Filter'
      end
    end

    it 'resets selected filter to default values' do
      within '#filters-form' do
        click_link 'Reset'
      end

      within '#filters-form' do
        within '#filters-predefined-ranges-toggle' do
          expect(page).to have_text filter_last_12_months_label
        end

        within '.filters-tags-container' do
          within '.select2-selection__rendered' do
            expect(page).to have_content tag1a.name
            expect(page).to have_content tag2c.name
          end
        end
      end
    end
  end

  private

  def assert_filters_set # rubocop:disable Metrics/AbcSize
    within '#filters-form' do
      within '#filters-predefined-ranges-toggle' do
        expect(page).to have_text filter_last_6_months_label
      end

      within '.filters-tags-container' do
        within '.select2-selection__rendered' do
          expect(page).to have_content tag2c.name
          expect(page).not_to have_content tag1a.name
        end
      end
    end
  end
end
