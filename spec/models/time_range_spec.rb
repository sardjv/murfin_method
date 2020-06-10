# == Schema Information
#
# Table name: time_ranges
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  value              :integer          not null
#  time_range_type_id :bigint           not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
describe TimeRange, type: :model do
  subject { build(:time_range) }

  it { expect(subject).to be_valid }

  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:time_range_type_id) }
  it { should validate_presence_of(:user_id) }
  it { should belong_to(:user) }

  context 'with end_time before start_time' do
    subject { build(:time_range) }

    before { subject.end_time = subject.start_time - 1.hour }

    it { expect(subject).not_to be_valid }
  end

  context 'with a couple of example types' do
    let(:jp_type) { create(:time_range_type, name: 'Job Plan Periods') }
    let(:rio_type) { create(:time_range_type, name: 'RIO Appointments') }

    context 'with a couple of example ranges' do
      let(:start_time) { DateTime.now.change({ hour: 9 }) }
      let(:end_time) { DateTime.now.change({ hour: 17 }) }
      let!(:job_plan_periods) {
        create(
          :time_range,
          time_range_type_id: jp_type.id,
          start_time: start_time,
          end_time: end_time,
          value: 2
        )
      }
      let!(:rio_appointments) {
        create(
          :time_range,
          time_range_type_id: jp_type.id,
          start_time: start_time,
          end_time: end_time + 1.hour,
          value: 3
        )
      }

      it { expect(job_plan_periods).to be_valid }
      it { expect(rio_appointments).to be_valid }
    end
  end
end
