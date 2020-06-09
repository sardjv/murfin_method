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
  it { expect(TimeRange.new).not_to be_valid }
  it { expect(build(:time_range)).to be_valid }

  context 'with a couple of example types' do
    let(:jp_type) { create(:time_range_type, name: 'Job Plan Period') }
    let(:rio_type) { create(:time_range_type, name: 'RIO Appointment') }

    context 'with a couple of example ranges' do
      let(:start_time) { DateTime.now.change({ hour: 9 }) }
      let(:end_time) { DateTime.now.change({ hour: 17 }) }
      let!(:job_plan_period) {
        create(
          :time_range,
          time_range_type_id: jp_type.id,
          start_time: start_time,
          end_time: end_time
        )
      }
      let!(:rio_appointment) {
        create(
          :time_range,
          time_range_type_id: jp_type.id,
          start_time: start_time,
          end_time: end_time + 1.hour
        )
      }

      it { expect(job_plan_period).to be_valid }
      it { expect(rio_appointment).to be_valid }
    end
  end
end
