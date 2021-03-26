# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  email                  :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  epr_uuid               :string(255)
#
describe User, type: :model do
  subject { build(:user) }

  it { expect(subject).to be_valid }

  it { should have_many(:time_ranges).dependent(:destroy) }
  it { should have_many(:notes_written).dependent(:restrict_with_error) }
  it { should have_many(:notes).dependent(:destroy) }
  it { should have_many(:plans).dependent(:destroy) }
  it { should have_many(:signoffs).dependent(:restrict_with_error) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_uniqueness_of(:epr_uuid).allow_blank }

  it { is_expected.to strip_attributes(:first_name, :last_name, :email, :epr_uuid) }
end
