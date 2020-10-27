# == Schema Information
#
# Table name: activities
#
#  id         :bigint           not null, primary key
#  schedule   :text(16777215)   not null
#  plan_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
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

  describe 'API' do
    context 'with a day and start_time' do
      let(:day) { 'monday' }
      let(:start_time) { Time.zone.today.to_time.in_time_zone + 9.hours }
      let(:end_time) { Time.zone.today.to_time.in_time_zone + 13.hours }

      before do
        subject.update(day: day, start_time: start_time, end_time: end_time)
      end

      it 'sets the attributes based on the plan' do
        expect(subject.day).to eq(day)
        expect(subject.start_time).to eq(subject.plan.start_date.to_time.in_time_zone + 9.hours)
        expect(subject.end_time).to eq(subject.plan.end_date.to_time.in_time_zone + 13.hours)
      end
    end

    context 'with end before start' do

    end
  end
end
