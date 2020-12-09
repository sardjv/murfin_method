# == Schema Information
#
# Table name: signoffs
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  signed_at  :datetime
#  revoked_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
describe Signoff, type: :model do
  subject { build(:signoff) }

  it { expect(subject).to be_valid }
  it { should belong_to(:user) }
  it { should belong_to(:plan) }
end
