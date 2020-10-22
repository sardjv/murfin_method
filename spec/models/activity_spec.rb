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

  it { should belong_to(:plan) }

  describe 'schedule' do
    let(:schedule) do
      IceCube::Schedule.new(Time.current) do |s|
        s.add_recurrence_rule(IceCube::Rule.weekly)
      end
    end

    subject { create(:activity, schedule: schedule) }

    it 'can be set' do
      expect(subject.reload.schedule).to eq(schedule)
    end
  end
end
