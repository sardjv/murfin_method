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
end
