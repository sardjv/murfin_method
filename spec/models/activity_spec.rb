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
  subject { build :activity, plan: plan }

  let(:plan) { build :plan, start_date: Date.parse('01/01/2020'), end_date: Date.parse('31/12/2020') }

  it { expect(subject).to be_valid }

  it { should belong_to(:plan) }
  it { should have_many(:tags).through(:tag_associations) }
  it { should accept_nested_attributes_for(:tag_associations).allow_destroy(true) }

  context 'with seconds_per_week' do
    before do
      subject.update(seconds_per_week: seconds_per_week)
    end

    context 'with 10 hours per week' do
      let(:seconds_per_week) { 10 * 60 * 60 }
      let(:time_range_value) { (seconds_per_week.to_f / 60 / 7) } # ~ 85m per day TODO change to value

      let(:activity_start_time) { Time.zone.local(2020, 1, 1, 9, 0) }
      let(:activity_end_time) { Time.zone.local(2020, 1, 1, 10, 25, 42) } # ~85m = 1h 25m per day

      it 'spreads it across the week' do
        expect(subject.days).to eq(%w[monday tuesday wednesday thursday friday saturday sunday])
        expect(subject.start_time).to eq activity_start_time
        expect(subject.end_time.to_s).to eq activity_end_time.to_s
        expect(subject.seconds_per_week).to eq(seconds_per_week)
      end

      describe 'to_bulk_time_range' do
        let(:result) { subject.to_bulk_time_range }
        let(:bulk_time_range_value) { 366 * time_range_value }

        it 'returns one bulk time range' do
          expect(result).to be_a TimeRange
          expect(result.value.to_i).to eql bulk_time_range_value.to_i
          expect(result.start_time.to_s).to eql plan.start_date.beginning_of_day.to_s
          expect(result.end_time.to_s).to eql plan.end_date.end_of_day.to_s
          expect(result.user_id).to eql plan.user_id
        end
      end

      describe 'to_time_ranges' do
        let(:result) { subject.to_time_ranges }

        it 'returns time ranges' do
          expect(result.count).to eql 366
          expect(result.first).to be_a(TimeRange)
          expect(result.first.value.to_i).to eq time_range_value.to_i
          expect(result.first.user_id).to eq plan.user_id
        end
      end

    end
  end

  context 'with some tags' do
    let!(:active) { create(:tag_type, active_for_activities: true, name: '1') }
    let!(:inactive) { create(:tag_type, active_for_activities: false, name: '2') }

    before { subject.tag_types << inactive }

    describe '#active_tag_associations' do
      it 'includes only active tags regardless of association' do
        expect(subject.active_tag_associations.map(&:tag_type_id)).to eq([active.id])
      end
    end
  end
end
