# == Schema Information
#
# Table name: signoffs
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  plan_id    :bigint           not null
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

  describe '#sign' do
    before { subject.sign }
    it { assert(subject.signed?) }
  end

  describe '#revoke' do
    before do
      subject.sign
      subject.revoke
    end

    it { refute(subject.signed?) }
  end

  describe '#signed?' do
    let(:subject) { build(:signoff, signed_at: signed_at, revoked_at: revoked_at) }
    let(:signed_at) { nil }
    let(:revoked_at) { nil }

    it { expect(subject.state).to eq(:unsigned) }
    it { assert(subject.unsigned?) }
    it { refute(subject.signed?) }
    it { refute(subject.revoked?) }

    context 'when signed' do
      let(:signed_at) { Time.current }
      it { expect(subject.state).to eq(:signed) }
      it { refute(subject.unsigned?) }
      it { assert(subject.signed?) }
      it { refute(subject.revoked?) }
    end

    context 'when signed and revoked' do
      let(:signed_at) { Time.current - 1.second }
      let(:revoked_at) { Time.current }
      it { expect(subject.state).to eq(:revoked) }
      it { refute(subject.unsigned?) }
      it { refute(subject.signed?) }
      it { assert(subject.revoked?) }
    end

    context 'when revoked and then signed again' do
      let(:revoked_at) { Time.current - 1.second }
      let(:signed_at) { Time.current }
      it { expect(subject.state).to eq(:signed) }
      it { refute(subject.unsigned?) }
      it { assert(subject.signed?) }
      it { refute(subject.revoked?) }
    end
  end
end
