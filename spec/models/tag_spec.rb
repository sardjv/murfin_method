# == Schema Information
#
# Table name: tags
#
#  id            :bigint           not null, primary key
#  content       :text(65535)      not null
#  taggable_type :string(255)
#  taggable_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
describe Tag, type: :model do
  subject { build(:tag) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
  it { should belong_to(:tag_type) }
  it { should validate_presence_of(:tag_type_id) }
  it { should have_many(:activity_tags).dependent(:destroy) }
  it { should have_db_index(%i[tag_type_id name]).unique }
  it { should validate_uniqueness_of(:name).scoped_to(:tag_type_id).ignoring_case_sensitivity }
end
