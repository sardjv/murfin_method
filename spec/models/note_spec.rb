# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  state      :integer          default("info"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_time :datetime
#  end_time   :datetime
#  author_id  :bigint
#
describe Note, type: :model do
  subject { build(:note) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }
  it { should validate_presence_of(:author_id) }
end
