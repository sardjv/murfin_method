# == Schema Information
#
# Table name: time_ranges
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  value              :integer          not null
#  time_range_type_id :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
describe TimeRange, type: :model do
  it { expect(TimeRange.new).to be_valid }
end
