# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:team) { create :team }
  let(:team2) { create :team, name: 'Team Two' }
  let!(:user) { create(:user, :admin, transaction_received_mail: false, goal_reached_mail: false, summary_mail: false) }
  let!(:user2) { create(:user, name: 'Henk') }

  before do
    team.add_member(user, true)
    team2.add_member(user2)
    sign_in user
  end

  describe 'GET #index' do
    before do
      get :index,
          params: {
              team: team.id
          }
    end

    it 'gets edit' do
      expect(response).to render_template(:index)
    end

    it 'returns a 200 (ok) status code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH #update' do
    context 'not updating the users preferences' do
      before do
        patch :update,
              params: {
                user: {
                  transaction_received_mail: false,
                  goal_reached_mail: false,
                  summary_mail: false
                },
                team: team.id
              }
      end

      it 'updates the users preferences' do
        user = User.find(self.user.id)

        expect(user.transaction_received_mail).to be(false)
        expect(user.goal_reached_mail).to be(false)
        expect(user.summary_mail).to be(false)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(dashboard_path(team: team))
      end

      it 'returns a 302 (found) status code' do
        expect(response).to have_http_status(302)
      end
    end

    context 'updating the users preferences' do
      before do
        patch :update,
              params: {
                user: {
                  transaction_received_mail: true,
                  goal_reached_mail: false,
                  summary_mail: true
                },
                team: team.id
              }
      end

      it 'updates the users preferences' do
        user = User.find(self.user.id)

        expect(user.transaction_received_mail).to be(true)
        expect(user.goal_reached_mail).to be(false)
        expect(user.summary_mail).to be(true)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(dashboard_path(team: team))
      end

      it 'returns a 302 (found) status code' do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'GET #users_autocomplete' do
    context 'with the name of a team member' do
      before do
        get :autocomplete_search, team: team.slug,
                                  term: user.name[0..1] # Cut off the name a bit
      end

      it 'returns the user John' do
        expect(response.body).to match("[#{user.name}]")
      end
    end

    context 'with the name of a user that is not in the same team' do
      before do
        get :autocomplete_search, team: team.slug, term: user2.name
      end

      it 'returns no users' do
        expect(response.body).to match('[]')
      end
    end
  end
end
