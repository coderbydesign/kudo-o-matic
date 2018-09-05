# frozen_string_literal: true

require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V2::TeamsController, type: :request do
  include RequestHelpers

  describe 'GET api/v2/teams/me' do
    let(:application) {create(:application)}
    let(:team) {create(:team)}
    let(:team2) {create :team, name: 'The Company', slug: 'the-company', created_at: Time.now + 1.hour}
    let(:team3) {create :team, name: 'The Invited', slug: 'the-invited', created_at: Time.now + 2.hour}
    let(:team4) {create :team, name: 'The Second Invited', slug: 'the-second-invited'}
    let(:team5) {create :team, name: 'The Third Invited', slug: 'the-third-invited'}
    let(:user) {create(:user)}
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let!(:invite) {TeamInvite.create(email: user.email, team: team3)}
    let!(:invite2) {TeamInvite.create(email: user.email, team: team4, accepted_at: Time.now)}
    let!(:invite3) {TeamInvite.create(email: user.email, team: team5, declined_at: Time.now)}
    let(:request) {'/api/v2/teams/me'}

    before do
      team.add_member(user)
      team2.add_member(user)
    end

    context 'with a valid api-token' do
      before do
        get request, format: :json, access_token: token.token
      end

      it 'returns a list of teams and one invite' do
        expected =
            {
                data: {
                    amountOfTeams: 2,
                    teams: [
                        {id: team.id, name: 'Kabisa', slug: 'kabisa', logo: ''},
                        {id: team2.id, name: 'The Company', slug: 'the-company', logo: ''}
                    ],
                    amountOfInvites: 1,
                    invites: [
                        {id: invite.id, name: 'The Invited', logo: ''},
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
