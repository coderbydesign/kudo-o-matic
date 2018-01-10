require 'rails_helper'

RSpec.describe LegalController, type: :controller do
  describe 'GET #privacy' do
    before do
      get :privacy
    end

    it 'gets privacy' do
      expect(response).to render_template(:privacy)
    end

    it 'returns a 200 (ok) status code' do
      expect(response).to have_http_status(200)
    end
  end
end
