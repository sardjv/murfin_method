describe Note, type: :model do
  subject { build(:note) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:content) }
end
