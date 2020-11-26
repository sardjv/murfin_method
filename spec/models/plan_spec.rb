# == Schema Information
#
# Table name: plans
#
#  id         :bigint           not null, primary key
#  start_date :date             not null
#  end_date   :date             not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
describe Plan, type: :model do
  subject { build(:plan) }

  it { expect(subject).to be_valid }

  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:user_id) }
  it { should belong_to(:user) }
  it { should have_many(:activities).dependent(:destroy) }
  it { should accept_nested_attributes_for(:activities).allow_destroy(true) }

  context 'with end_date before start_date' do
    subject { build(:plan) }

    before { subject.end_date = subject.start_date - 1.day }

    it { expect(subject).not_to be_valid }
  end

  context 'with end_date equal to start_date' do
    subject { build(:plan) }

    before { subject.end_date = subject.start_date }

    it { expect(subject).not_to be_valid }
  end

  describe '#name' do
    it { expect(subject.name).to eq("#{subject.user.name}'s #{subject.start_date.year} #{I18n.t('plan.name')}") }
  end

  describe '#to_time_ranges' do
    let(:subject) do
      create(
        :plan,
        start_date: Time.zone.local(2019, 11, 5),
        end_date: Time.zone.local(2020, 11, 4, 23, 59, 59),
        activities: [create(:activity, seconds_per_week: 60 * 60)]
      )
    end

    it 'counts the days correctly' do
      days_in_leap_year = 366
      minutes_per_week = 60
      days_per_week = 7
      minutes_worked_in_year = (minutes_per_week.to_f / days_per_week) * days_in_leap_year

      expect(subject.to_time_ranges.sum(&:value).round(7)).to eq(minutes_worked_in_year.round(7))
    end
  end
end
