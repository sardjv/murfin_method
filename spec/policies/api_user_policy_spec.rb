describe ApiUserPolicy do
  subject { described_class }

  permissions :index?, :create?, :update?, :edit?, :show?, :destroy?, :generate_token? do
    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(build(:user), create(:api_user))
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(create(:admin), create(:api_user))
    end
  end
end
