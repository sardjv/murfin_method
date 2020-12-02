# == Schema Information
#
# Table name: activity_tags
#
#  id          :bigint           not null, primary key
#  tag_id      :bigint
#  activity_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tag_type_id :bigint           not null
#
describe ActivityTag, type: :model do
  subject { build(:activity_tag) }

  it { expect(subject).to be_valid }
  it { should belong_to(:tag_type) }
  it { should belong_to(:tag).optional }
  it { should belong_to(:activity) }
  it { should have_db_index(%i[activity_id tag_type_id tag_id]).unique }
  it { should validate_uniqueness_of(:activity_id).scoped_to(%i[tag_type_id tag_id]) }

  context 'when tag.tag_type != tag_type' do
    # Types.
    let!(:type) { create(:tag_type) }
    let!(:unrelated_type) { create(:tag_type) }

    # Tags.
    let!(:tag) { create(:tag, tag_type: type) }

    # ActivityTag.
    let(:subject) { build(:activity_tag, tag_type: unrelated_type, tag: tag) }

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

    # ActivityTags.
    let!(:chosen_category) { create(:activity_tag, tag_type: category, tag: dcc_category) }
    let(:chosen_subcategory) { build(:activity_tag, tag_type: subcategory, tag: spa_subcategory) }

    it { expect(chosen_subcategory).not_to be_valid }
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

    # ActivityTags.
    let!(:chosen_category) { create(:activity_tag, activity: activity, tag_type: category, tag: dcc_category) }
    let!(:chosen_subcategory) { create(:activity_tag, activity: activity.reload, tag_type: subcategory, tag: dcc_subcategory) }

    before do
      activity.reload
      chosen_category.assign_attributes(tag: spa_category)
    end

    it { expect(chosen_category).not_to be_valid }
  end
end
