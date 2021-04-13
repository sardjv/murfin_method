describe UserPolicy do
  subject { described_class }

  permissions :index?, :create?, :update?, :edit?, :destroy? do
    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(create(:user), create(:user))
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(create(:admin), create(:user))
    end
  end
end
