# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let!(:user) {create(:user, :admin)}
  let!(:team) { create(:team) }
  let!(:balance) {create :balance, current: :current, team_id: team.id}
  let!(:goal) {create(:goal)}
  let!(:transaction) {create(:transaction, team_id: team.id, balance: balance)}

  before do
    team.add_member(user)
    sign_in user
    @current_team = team.id
  end

  describe 'GET #show' do
    before do
      get :show, params: {id: transaction.id, tenant: team.slug}
    end

    it 'gets show' do
      expect(response).to render_template(:show)
    end

    it 'returns a 200 (ok) status code' do
      expect(response).to have_http_status(200)
    end
  end
end
