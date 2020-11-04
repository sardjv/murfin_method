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

  context 'with a day and start_time' do
    let(:days) { ['wednesday'] }
    let(:start_time) { { 4 => '09', 5 => '00' } }
    let(:end_time) { { 4 => '13', 5 => '00' } }

    before do
      subject.update(days: days, start_time: start_time, end_time: end_time)
    end

    context 'when updating all' do
      it 'sets the attributes' do
        expect(subject.days).to eq(days)
        expect(subject.start_time).to eq(Time.zone.local(1, 1, 1, 9, 0))
        expect(subject.end_time).to eq(Time.zone.local(1, 1, 1, 13, 0))
      end
    end

    context 'with end equals start' do
      let(:end_time) { start_time }

      it { expect(subject).not_to be_valid }
    end

    context 'with end before start' do
      let(:end_time) { { 4 => '08', 5 => '00' } }

      it { expect(subject).not_to be_valid }
    end

    describe 'to_time_ranges' do
      it { expect(subject.to_time_ranges.first).to be_a(TimeRange) }
      it { expect(subject.to_time_ranges.first.value).to eq(240) } # Minutes in 4 hours.
      it { expect(subject.to_time_ranges.first.user_id).to eq(subject.plan.user_id) }
    end
  end
end
