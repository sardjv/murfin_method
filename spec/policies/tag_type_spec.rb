describe TagTypePolicy do
  subject { described_class }

  permissions :index?, :create?, :update?, :edit?, :destroy? do
    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(create(:user), create(:tag_type))
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(create(:admin), create(:tag_type))
    end
  end
end
