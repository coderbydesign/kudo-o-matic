require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V2::TeamsController, type: :request do
  include RequestHelpers

  describe 'GET api/v2/teams/me' do
    let(:application) { create(:application) }
    let(:team) { create(:team) }
    let(:team2) { create :team, name: 'The Company', slug: 'the-company' }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:request) { '/api/v2/teams/me' }

    before do
      team.add_member(user)
      team2.add_member(user)
    end

    context 'with a valid api-token' do
      before do
        get request, format: :json, access_token: token.token
      end

      it 'returns a list of teams' do
        expected =
          {
            data: {
              amountOfTeams: 2,
              teams: [
                {
                  id: team.id,
                  name: team.name,
                  slug: team.slug,
                  logo: ''
                },
                {
                  id: team2.id,
                  name: team2.name,
                  slug: team2.slug,
                  logo: ''
                }
              ]
            }
          }.with_indifferent_access

        expect(json).to eq(expected)
      end

      expect_status_200_ok
    end

    context 'with an invalid api-token' do
      before do
        get request, format: :json, access_token: 'Invalid token'
      end

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
