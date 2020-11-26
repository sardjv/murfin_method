# == Schema Information
#
# Table name: activity_tags
#
#  id          :bigint           not null, primary key
#  tag_id      :bigint           not null
#  activity_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
describe ActivityTag, type: :model do
  subject { build(:activity_tag) }

  it { expect(subject).to be_valid }
  it { should belong_to(:tag) }
  it { should validate_presence_of(:tag_id) }
  it { should belong_to(:activity) }
  it { should validate_presence_of(:activity_id) }
  it { should have_db_index(%i[tag_id activity_id]).unique }
  it { should validate_uniqueness_of(:activity_id).scoped_to(:tag_id) }
end
