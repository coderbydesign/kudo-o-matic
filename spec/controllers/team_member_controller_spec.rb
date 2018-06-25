# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMemberController, type: :controller do
  let!(:user) {create(:user)}
  let!(:user2) { create :user, name:'Henk', email:'henk@example.com' }
  let!(:user3) { create(:user, name: 'Jan', email: 'jan@example.com') }
  let!(:team) {create :team}

  before do
    team.add_member(user, true)
    team.add_member(user2)
  end

  describe 'GET #index' do
    before do
      sign_in user
      get :index, team: team.slug
    end

    it 'gets index' do
      expect(response).to render_template(:index)
    end

    it 'returns a 200 (ok) status code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE #delete' do
    let!(:membership) {team.memberships.last}

    before do
      sign_in user
      delete 'delete', id: membership.id, team: team.slug
    end

    it 'removes the membership' do
      expect(membership.id).to_not eql(team.memberships.last.id)
    end

    it 'redirects to team members page' do
      expect(response).to redirect_to(manage_team_members_path(team: team.slug))
    end
  end

end