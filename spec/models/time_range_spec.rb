# == Schema Information
#
# Table name: time_ranges
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  value              :decimal(65, 30)  not null
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
  it { should belong_to(:time_range_type) }
  it { should belong_to(:user) }

  describe '#value' do
    context 'with a longer float' do
      let(:value) { 3137.142857142857143 }
      let(:subject) { create(:time_range, value: value) }

      it { expect(subject.reload.value).to eq(value) }
    end
  end

  context 'with end_time before start_time' do
    subject { build(:time_range) }

    before { subject.end_time = subject.start_time - 1.hour }

    it { expect(subject).not_to be_valid }
  end

  context 'with end_time equal to start_time' do
    subject { build(:time_range) }

    before { subject.end_time = subject.start_time }

    it { expect(subject).not_to be_valid }
  end

  context 'with a couple of example types' do
    let(:jp_type) { create(:time_range_type, name: 'Job Plan Periods') }
    let(:rio_type) { create(:time_range_type, name: 'RIO Appointments') }

    context 'with a couple of example ranges' do
      let!(:job_plan_periods) do
        create(
          :time_range,
          time_range_type_id: jp_type.id,
          start_time: DateTime.now.change({ hour: 9 }),
          end_time: DateTime.now.change({ hour: 17 }),
          value: 2
        )
      end
      let!(:rio_appointments) do
        create(
          :time_range,
          time_range_type_id: rio_type.id,
          start_time: DateTime.now.change({ hour: 9 }),
          end_time: DateTime.now.change({ hour: 18 }),
          value: 3
        )
      end

      it { expect(job_plan_periods).to be_valid }
      it { expect(rio_appointments).to be_valid }
    end

    describe '#segment_value' do
      subject do
        create(
          :time_range,
          start_time: Time.zone.local(2020, 1, 1, 9),
          end_time: Time.zone.local(2020, 1, 1, 10),
          value: 10
        )
      end

      let(:result) { subject.segment_value(segment_start: segment_start, segment_end: segment_end) }

      context 'with a total intersection' do
        context 'when 0% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 10, 1) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 11) }

          it { expect(result).to eq(0) }
        end

        context 'when 25% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 9) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 9, 15) }

          it { expect(result).to eq(2.5) }
        end

        context 'when 50% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 9) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 9, 30) }

          it { expect(result).to eq(5) }
        end

        context 'when 100% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 9) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 10) }

          it { expect(result).to eq(10) }
        end
      end

      context 'with a partial intersect from the start' do
        context 'when 25% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 8) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 9, 15) }

          it { expect(result).to eq(2.5) }
        end

        context 'when 50% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 8) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 9, 30) }

          it { expect(result).to eq(5) }
        end

        context 'when 100% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 8) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 10) }

          it { expect(result).to eq(10) }
        end
      end

      context 'with a partial intersect from the middle' do
        context 'when 25% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 9, 45) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 10, 15) }

          it { expect(result).to eq(2.5) }
        end

        context 'when 50% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 9, 30) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 10, 15) }

          it { expect(result).to eq(5) }
        end

        context 'when 100% is overlapped' do
          let(:segment_start) { Time.zone.local(2020, 1, 1, 8, 45) }
          let(:segment_end) { Time.zone.local(2020, 1, 1, 10, 15) }

          it { expect(result).to eq(10) }
        end
      end
    end
  end
end
