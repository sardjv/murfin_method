# == Schema Information
#
# Table name: tag_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
describe TagType, type: :model do
  subject { build(:tag_type) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_db_index(:name).unique }
  it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
  it { should belong_to(:parent).class_name('TagType').optional }
  it { should have_many(:children).class_name('TagType').dependent(:nullify) }

  context 'with an infinite loop of parents' do
    let!(:grandparent) { create(:tag_type) }
    let!(:parent) { create(:tag_type, parent_id: grandparent.id) }
    let!(:child) { create(:tag_type, parent_id: parent.id) }

    before { grandparent.update(parent_id: child.id) }

    it { expect(grandparent).not_to be_valid }
  end
end
