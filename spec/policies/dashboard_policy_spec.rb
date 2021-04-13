describe DashboardPolicy do
  subject { described_class }

  permissions :admin_dashboard? do
    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(create(:user))
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(create(:admin))
    end
  end
end
