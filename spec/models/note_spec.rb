# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  state      :integer          default("info"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
describe Note, type: :model do
  subject { build(:note) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:content) }
end
