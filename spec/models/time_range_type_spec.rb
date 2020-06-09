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
  it { expect(TimeRangeType.new).to be_valid }
end
