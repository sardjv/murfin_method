# == Schema Information
#
# Table name: tags
#
#  id          :bigint           not null, primary key
#  name        :string(255)      not null
#  tag_type_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :bigint
#
describe Tag, type: :model do
  subject { build(:tag) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
  it { should belong_to(:tag_type) }
  it { should have_many(:activity_tags).dependent(:restrict_with_error) }
  it { should have_db_index(%i[parent_id name]).unique }
  it { should validate_uniqueness_of(:name).scoped_to(:parent_id).ignoring_case_sensitivity }
  it { should belong_to(:parent).class_name('Tag').optional }
  it { should have_many(:children).class_name('Tag').dependent(:nullify) }

  context 'when parent.tag_type equals tag_type.parent' do
    # Types.
    let!(:parent_type) { create(:tag_type) }
    let!(:child_type) { create(:tag_type, parent: parent_type) }

    # Tags.
    let!(:parent_tag) { create(:tag, tag_type: parent_type) }
    let!(:child_tag) { build(:tag, tag_type: child_type, parent: parent_tag) }

    it { expect(child_tag).to be_valid }
  end

  context 'when parent.tag_type != tag_type.parent' do
    # Types.
    let!(:parent_type) { create(:tag_type) }
    let!(:unrelated_parent_type) { create(:tag_type) }
    let!(:child_type) { create(:tag_type, parent: parent_type) }

    # Tags.
    let!(:parent_tag) { create(:tag, tag_type: parent_type) }
    let!(:unrelated_parent_tag) { create(:tag, tag_type: unrelated_parent_type) }
    let!(:child_tag) { build(:tag, tag_type: child_type, parent: unrelated_parent_tag) }

    it { expect(child_tag).not_to be_valid }
  end

  context 'with an activity_tag' do
    subject { create(:tag) }
    let!(:activity_tag) { create(:activity_tag, tag: subject) }

    describe 'destroying' do
      it { expect { subject.destroy! }.to raise_error }
    end
  end
end
