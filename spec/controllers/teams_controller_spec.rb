require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let!(:user) { create(:user, :admin) }

  before do
    sign_in user
  end

  describe 'GET #new' do
    before do
      get :new
    end

    it 'gets new' do
      expect(response).to render_template(:new)
    end

    it 'returns a 200 (ok) status code' do
      expect(response).to have_http_status(200)
    end
  end
end
