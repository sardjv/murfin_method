# == Schema Information
#
# Table name: activities
#
#  id                 :bigint           not null, primary key
#  schedule           :mediumtext       not null
#  plan_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
describe Activity, type: :model do
  subject { build(:activity) }

  it { expect(subject).to be_valid }

  it { should validate_presence_of(:schedule) }
  it { should belong_to(:plan) }
end
