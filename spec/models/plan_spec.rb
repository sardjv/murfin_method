# == Schema Information
#
# Table name: plans
#
#  id                          :bigint           not null, primary key
#  start_date                  :date             not null
#  end_date                    :date             not null
#  user_id                     :bigint           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  contracted_minutes_per_week :integer
#
describe Plan, type: :model do
  subject { build(:plan) }

  it { should belong_to(:user) }
  it { should have_many(:activities).dependent(:destroy) }
  it { should have_many(:signoffs).dependent(:destroy) }

  it { expect(subject).to be_valid }

  it { should accept_nested_attributes_for(:activities).allow_destroy(true) }

  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_numericality_of(:contracted_minutes_per_week) }

  context 'with nil user_id' do
    subject { build(:plan, user_id: nil) }
    it 'validates existence of user' do
      expect(subject).not_to be_valid
      messages = subject.errors.full_messages
      expect(messages).to include('User must exist')
    end
  end

  context 'with non existent user' do
    subject { build(:plan, user_id: 123) }
    it 'validates existence of user' do
      expect(subject).not_to be_valid
      messages = subject.errors.full_messages
      expect(messages).to include('User must exist')
    end
  end

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
    it {
      expect(subject.name).to eq("#{subject.user.name}'s #{subject.start_date.year} #{Plan.model_name.human.titleize}")
    }
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

  context 'with some signoffs' do
    let(:owner) { create(:user) }
    subject do
      create(
        :plan,
        user: owner,
        signoffs: [
          create(:signoff, user: owner, signed_at: owner_signed_at),
          create(:signoff, user: create(:user), signed_at: user1_signed_at),
          create(:signoff, user: create(:user), signed_at: user2_signed_at)
        ]
      )
    end
    let(:owner_signed_at) { nil }
    let(:user1_signed_at) { nil }
    let(:user2_signed_at) { nil }

    describe '#state' do
      context 'with none signed' do
        it { expect(subject.state).to eq(:draft) }
        it { assert(subject.draft?) }
        it { refute(subject.submitted?) }
        it { refute(subject.complete?) }
      end

      context 'with only owner signed' do
        let(:owner_signed_at) { Time.current }
        it { expect(subject.state).to eq(:submitted) }
        it { refute(subject.draft?) }
        it { assert(subject.submitted?) }
        it { refute(subject.complete?) }
      end

      context 'with one other signed' do
        let(:owner_signed_at) { Time.current }
        let(:user1_signed_at) { Time.current }
        it { expect(subject.state).to eq(:submitted) }
        it { refute(subject.draft?) }
        it { assert(subject.submitted?) }
        it { refute(subject.complete?) }
      end

      context 'with all signed' do
        let(:owner_signed_at) { Time.current }
        let(:user1_signed_at) { Time.current }
        let(:user2_signed_at) { Time.current }
        it { expect(subject.state).to eq(:complete) }
        it { refute(subject.draft?) }
        it { refute(subject.submitted?) }
        it { assert(subject.complete?) }
      end

      context 'with all except owner signed' do
        let(:user1_signed_at) { Time.current }
        let(:user2_signed_at) { Time.current }
        it { expect(subject.state).to eq(:draft) }
        it { assert(subject.draft?) }
        it { refute(subject.submitted?) }
        it { refute(subject.complete?) }
      end
    end
  end

  describe '#required_signoffs' do
    subject { build(:plan) }

    it 'always includes owner' do
      expect(subject.required_signoffs.first.user_id).to eq(subject.user_id)
    end
  end
end
