describe PlanPolicy do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, user: user) }
  let(:signatory) { create(:user) }
  let!(:signoff) { create(:signoff, user: signatory, plan: plan) }
  let(:plan2) { create(:plan, user: create(:user)) }
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it "denies access if user doesn't own plan" do
      expect(subject).not_to permit(user, plan2)
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(create(:admin), plan)
    end

    it 'grants access if user owns plan' do
      expect(subject).to permit(user, plan)
    end
  end

  permissions :edit? do
    it "denies access if user doesn't own plan" do
      expect(subject).not_to permit(user, plan2)
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(create(:admin), plan)
    end

    it 'grants access if user owns plan' do
      expect(subject).to permit(user, plan)
    end

    it 'grants access if user is a signatory' do
      expect(subject).to permit(signatory, plan)
    end

    context "when user is manager of the owner's team" do
      let(:manager) { create(:user) }
      let(:user_group) { create(:user_group) }
      let!(:lead_membership) { create(:membership, user_group: user_group, user: manager, role: 'lead') }
      let!(:user_membership) { create(:membership, user_group: user_group, user: user, role: 'member') }
      it 'grants access' do
        expect(subject).to permit(manager, plan)
      end
    end
  end

  permissions :change_user? do
    it 'denies access if plan is persisted' do
      expect(subject).not_to permit(create(:admin), plan)
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(create(:admin), build(:plan))
    end
  end
end
