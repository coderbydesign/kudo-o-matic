# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let!(:user) { create(:user, :admin) }
  let!(:team) { create(:team) }
  let!(:team2) { create(:team, name: 'The Company', slug: 'the-company') }
  let!(:balance) { create :balance, current: :current, team_id: team.id }
  let!(:goal) { create(:goal) }
  let!(:transaction) { create(:transaction, team_id: team.id, balance: balance) }

  before do
    team.add_member(user)
    sign_in user
  end

  describe 'GET #show' do
    context 'with a valid membership' do
      before do
        get :show, params: { id: transaction.id, tenant: team.slug }
      end

      it 'gets show' do
        expect(response).to render_template(:show)
      end

      it 'returns a 200 (ok) status code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with a invalid membership' do
      before do
        get :show, params: { id: transaction.id, tenant: team2.slug }
      end

      it 'gets teams/access_denied' do
        expect(response).to render_template('teams/access_denied')
      end

      it 'returns a 403 (forbidden) status code' do
        expect(response).to have_http_status(403)
      end
    end

    context 'with a non-existing team' do
      it 'raises an ActiveRecord::NotFound error' do
        expect {
          get :show, params: { id: transaction.id, tenant: 'non-existing-team' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
