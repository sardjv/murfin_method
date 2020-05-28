describe ApiToken, type: :model do
  it { expect(ApiToken.new).to be_valid }

  context 'with a persisted token' do
    let!(:api_token) { create(:api_token) }

    it 'generates a token' do
      expect(api_token.content).not_to be_blank
    end
  end
end
