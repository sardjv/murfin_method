# == Schema Information
#
# Table name: time_range_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
describe TimeRangeType, type: :model do
  subject { build(:time_range_type) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
  it { should have_db_index(:name).unique }
  it { should have_many(:time_ranges).dependent(:destroy) }
end
