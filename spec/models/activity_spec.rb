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
  it { should have_many(:tags).through(:tag_associations) }
  it { should accept_nested_attributes_for(:tag_associations).allow_destroy(true) }

  context 'with seconds_per_week' do
    before do
      subject.update(seconds_per_week: seconds_per_week)
    end

    context 'with 7 hours' do
      let(:seconds_per_week) { 7 * 60 * 60 }

      it 'spreads it across the week' do
        expect(subject.days).to eq(%w[monday tuesday wednesday thursday friday saturday sunday])
        expect(subject.start_time).to eq(Time.zone.local(1, 1, 1, 9, 0))
        expect(subject.end_time).to eq(Time.zone.local(1, 1, 1, 10, 0))
        expect(subject.seconds_per_week).to eq(seconds_per_week)
      end

      describe 'to_time_ranges' do
        it { expect(subject.to_time_ranges.first).to be_a(TimeRange) }
        it { expect(subject.to_time_ranges.first.value).to eq(60) } # Minutes in 1 hour.
        it { expect(subject.to_time_ranges.first.user_id).to eq(subject.plan.user_id) }
      end
    end
  end
end
