# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  first_name :string(255)      not null
#  last_name  :string(255)      not null
#  email      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin      :boolean          default(FALSE), not null
#
describe User, type: :model do
  subject { build(:user) }

  it { expect(subject).to be_valid }
  it { should have_many(:time_ranges).dependent(:destroy) }
  it { should have_many(:notes_written).dependent(:restrict_with_exception) }
  it { should have_many(:notes).dependent(:destroy) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
end
