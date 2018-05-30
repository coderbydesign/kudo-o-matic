# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamSelectorController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:team) { create :team }
  let!(:team2) { create :team, name: 'Team Two', slug: 'team-two' }

  before do
    team.add_member(user)
    team2.add_member(user)
    team2.add_member(user2)
  end

  describe 'GET #index' do
    context 'with a user who has multiple teams' do
      before do
        sign_in user
        get :index
      end

      it 'gets index' do
        expect(response).to render_template('team_selector/index')
      end

      it 'returns a 200 (ok) status code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with a user who only has one team' do
      before do
        sign_in user2
        get :index
      end

      it 'redirects to that team' do
        expect(response).to redirect_to(dashboard_path(team: team2.slug))
      end
    end
  end
end
