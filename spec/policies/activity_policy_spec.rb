describe ActivityPolicy do
  let(:user) { create(:user) }
  let(:activity) { create(:activity, plan: build(:plan, user: user)) }
  let(:activity2) { create(:activity, plan: build(:plan, user: create(:user))) }
  subject { described_class }

  permissions :update? do
    it "denies access if user doesn't own plan" do
      expect(subject).not_to permit(user, activity2)
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(create(:admin), activity)
    end

    it 'grants access if user owns plan' do
      expect(subject).to permit(user, activity)
    end
  end
end
