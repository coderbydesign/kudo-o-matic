require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let!(:user) {create(:user, :admin)}
  let!(:balance) {create(:balance, :current)}
  let!(:goal) {create(:goal)}
  let!(:transaction) {create(:transaction)}

  before do
    sign_in user
  end

  describe 'GET #show' do
    before do
      get :show, params: {id: transaction.id}
    end

    it 'gets show' do
      expect(response).to render_template(:show)
    end

    it 'returns a 200 (ok) status code' do
      expect(response).to have_http_status(200)
    end
  end
end
