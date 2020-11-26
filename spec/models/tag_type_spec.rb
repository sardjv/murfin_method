# == Schema Information
#
# Table name: tag_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
describe TagType, type: :model do
  subject { build(:tag_type) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_db_index(:name).unique }
  it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
end
