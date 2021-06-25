# == Schema Information
#
# Table name: tag_associations
#
#  id            :bigint           not null, primary key
#  tag_id        :bigint
#  taggable_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tag_type_id   :bigint           not null
#  taggable_type :string(255)      not null
#
describe TagAssociation, type: :model do
  subject { build(:tag_association) }

  it { expect(subject).to be_valid }
  it { should belong_to(:tag) }
  it { should belong_to(:taggable) }
  it { should have_db_index(%i[taggable_type taggable_id tag_type_id tag_id]).unique }
  it { should validate_uniqueness_of(:taggable_id).scoped_to(%i[taggable_type tag_type_id tag_id]) }

  describe 'tag type validation' do
    context 'tag type not set and can not be obtained from tag' do
      let(:subject) { build :tag_association, tag_type: nil, tag: nil }

      it { expect(subject).not_to be_valid }
    end

    context 'tag type not set but can be obtained from tag' do
      let(:subject) { build :tag_association, tag_type: nil, tag: create(:tag) }

      it { expect(subject).to be_valid }
    end
  end

  describe 'validate_tag_type_active_for_taggables' do
    let(:tag) { create :tag, tag_type: tag_type }
    let(:subject) { build :tag_association, taggable: taggable, tag: tag, tag_type: tag_type }

    context 'tag type active for taggable' do
      before do
        subject.save
      end

      context 'taggable is activity' do
        let(:taggable) { create :activity }
        let(:tag_type) { create :tag_type, active_for_activities_at: 1.week.ago }

        it { expect(subject).to be_valid }
      end

      context 'taggable is time range' do
        let(:taggable) { create :time_range }
        let(:tag_type) { create :tag_type, active_for_time_ranges_at: 1.week.ago }
        let(:error) { 'must be active for time ranges' }

        it { expect(subject).to be_valid }
      end

      before do
        subject.save
      end
    end

    context 'tag type not active for taggable' do
      before do
        subject.save
      end

      context 'taggable is activity' do
        let(:taggable) { create :activity }
        let(:tag_type) { create :tag_type, active_for_activities_at: nil }
        let(:error) { 'must be active for activities' }

        it { expect(subject).not_to be_valid }
        it { expect(subject.errors.messages_for(:tag_type_id)).to match_array([error]) }
      end

      context 'taggable is time range' do
        let(:taggable) { create :time_range }
        let(:tag_type) { create :tag_type, active_for_time_ranges_at: nil }
        let(:error) { 'must be active for time ranges' }

        it { expect(subject).not_to be_valid }
        it { expect(subject.errors.messages_for(:tag_type_id)).to match_array([error]) }
      end
    end
  end

  context 'when tag.tag_type != tag_type' do
    # Types.
    let!(:type) { create(:tag_type) }
    let!(:unrelated_type) { create(:tag_type) }

    # Tags.
    let!(:tag) { create(:tag, tag_type: type) }

    # TagAssociation.
    let(:subject) { build(:tag_association, tag_type: unrelated_type, tag: tag) }

    it { expect(subject).not_to be_valid }
  end

  context 'when tag_type.parent != tag.parent' do
    # Types.
    let!(:category) { create(:tag_type, name: 'Category') }
    let!(:subcategory) { create(:tag_type, name: 'Subcategory', parent: category) }

    # Tags.
    let!(:dcc_category) { create(:tag, name: 'DCC', tag_type: category) }
    let!(:spa_category) { create(:tag, name: 'SPA', tag_type: category) }
    let!(:spa_subcategory) { create(:tag, name: 'Outpatient', tag_type: subcategory, parent: spa_category) }

    # TagAssociations.
    let!(:chosen_category) { create(:tag_association, tag_type: category, tag: dcc_category) }
    let(:chosen_subcategory) { build(:tag_association, tag_type: subcategory, tag: spa_subcategory) }

    it { expect(chosen_subcategory).not_to be_valid }
  end

  context 'when tag_type.parent.tag == nil' do
    let!(:activity) { create(:activity) }

    # Types.
    let!(:category) { create(:tag_type, name: 'Category') }
    let!(:subcategory) { create(:tag_type, name: 'Subcategory', parent: category) }

    # Tags.
    let!(:spa_category) { create(:tag, name: 'SPA', tag_type: category) }
    let!(:spa_subcategory) { create(:tag, name: 'Outpatient', tag_type: subcategory, parent: spa_category) }

    # TagAssociations.
    let!(:chosen_category) { create(:tag_association, taggable: activity, tag_type: category, tag: spa_category) }
    let!(:chosen_subcategory) do
      build(:tag_association, taggable: activity, tag_type: subcategory, tag: spa_subcategory)
    end

    before do
      activity.reload
      chosen_subcategory.save!
      activity.reload
      chosen_category.assign_attributes(tag: nil)
    end

    it { expect(chosen_category).not_to be_valid }
  end

  context 'when tag_type.child != tag.tag_type' do
    let!(:activity) { create(:activity) }
    # Types.
    let!(:category) { create(:tag_type, name: 'Category') }
    let!(:subcategory) { create(:tag_type, name: 'Subcategory', parent: category) }

    # Tags.
    let!(:dcc_category) { create(:tag, name: 'DCC', tag_type: category) }
    let!(:spa_category) { create(:tag, name: 'SPA', tag_type: category) }
    let!(:dcc_subcategory) { create(:tag, name: 'Surgery', tag_type: subcategory, parent: dcc_category) }

    # TagAssociations.
    let!(:chosen_category) { create(:tag_association, taggable: activity, tag_type: category, tag: dcc_category) }
    let!(:chosen_subcategory) do
      create(:tag_association, taggable: activity.reload, tag_type: subcategory, tag: dcc_subcategory)
    end

    before do
      activity.reload
      chosen_category.assign_attributes(tag: spa_category)
    end

    it { expect(chosen_category).not_to be_valid }
  end
end
