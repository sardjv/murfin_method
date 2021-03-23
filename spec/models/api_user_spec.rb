# == Schema Information
#
# Table name: api_users
#
#  id                 :bigint           not null, primary key
#  name               :string(255)      not null
#  contact_email      :string(255)
#  created_by         :string(255)
#  token_generated_by :string(255)
#  token_sample       :string(255)
#  token_generated_at :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
describe ApiUser, type: :model do
  subject { build(:api_user) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
  it { is_expected.to strip_attributes(:name, :contact_email) }
end
