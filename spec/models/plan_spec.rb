# == Schema Information
#
# Table name: plans
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
describe Plan, type: :model do
  subject { build(:plan) }

  it { expect(subject).to be_valid }

  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }

  context 'with end_time before start_time' do
    subject { build(:plan) }

    before { subject.end_time = subject.start_time - 1.hour }

    it { expect(subject).not_to be_valid }
  end
end
