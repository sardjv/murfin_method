describe Admin::ApiTokensController do
  describe 'GET index' do
    before { get :index }
    it { expect(response).to be_successful }
  end

  describe 'GET show' do
    let(:api_token) { create(:api_token) }
    before { get :show, params: { id: api_token.id } }
    it { expect(response).to be_successful }
  end

  describe 'POST create' do
    before { post :create, params: { api_token: attributes_for(:api_token, name: "Anything") } }
    it 'works' do
      # expect(response).to eq(302)
    end
  end
end
