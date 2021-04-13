describe SignoffPolicy do
  let(:user) { create(:user) }
  let(:signoff) { create(:signoff, user: user) }
  let(:signoff2) { create(:signoff, user: create(:user)) }

  subject { described_class }

  permissions :sign?, :revoke? do
    it 'denies access if user not a signatory' do
      expect(subject).not_to permit(user, signoff2)
    end

    it 'grants access if user is an signatory' do
      expect(subject).to permit(user, signoff)
    end
  end
end
