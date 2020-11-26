# == Schema Information
#
# Table name: tags
#
#  id            :bigint           not null, primary key
#  content       :text(65535)      not null
#  taggable_type :string(255)
#  taggable_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
describe Tag, type: :model do
  subject { build(:tag) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:taggable_id) }
  it { should belong_to(:taggable) }
end
