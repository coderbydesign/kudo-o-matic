# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamInviteController, type: :controller do
  let!(:user) { create(:user) }
  let!(:team) { create :team }
  let!(:invite) { TeamInvite.create(email: user.email, team: team) }

  describe 'PUT #accept' do
    before do
      sign_in user
      put :accept, id: invite.id
    end

    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'PUT #decline' do
    before do
      sign_in user
      put :accept, id: invite.id
    end

    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #index' do
    context 'as team manager' do
      before do
        sign_in user
        team.add_member(user, true)
        get :index, id: invite.id, team: team.slug
      end

      it 'gets index' do
        expect(response).to render_template(:index)
      end

      it 'returns a 200 (ok) status code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'as not team manager' do
      before do
        sign_in user
        get :index, id: invite.id, team: team.slug
      end

      it 'redirects to dashboard' do
        expect(response).to redirect_to(dashboard_path(team: team.slug))
      end
    end
  end

  describe 'DELETE #delete' do
    context 'as manager' do
      before do
        sign_in user
        team.add_member(user, true)
      end

      it 'deletes the invite' do
        expect {
          delete 'delete', id: invite.id, team: team.slug
        }.to change(TeamInvite, :count).by(-1)
      end
    end
  end
end
