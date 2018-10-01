require 'rails_helper'

RSpec.describe GuidelinesController, type: :controller do
  let!(:user) { create(:user, :admin) }
  let!(:user_unauthorized) { create(:user)}
  let!(:team) { create(:team) }
  let!(:balance) { create :balance, current: :current, team_id: team.id }
  let!(:goal) { create(:goal) }
  let!(:guideline) { create :guideline, kudos: 5, team_id: team.id }

  before do
    sign_in user
    team.add_member(user, true)
  end

  describe 'GET #index' do
    before do
      get :index, team: team
    end

    it 'gets index' do
      expect(response).to render_template(:index)
    end

    it 'returns a 200 (ok) status code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #edit' do
    before do
      get :edit, id: guideline.id, team: team
    end

    it 'gets edit' do
      expect(response).to render_template(:edit)
    end

    it 'returns a 200 (ok) status code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'delete #destroy' do

    it 'deletes the guideline' do
      expect {
        delete 'destroy', id: guideline.id, team: team
      }.to change(Guideline, :count).by(-1)
    end
  end
end