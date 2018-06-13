# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamInviteController, type: :controller do
  let!(:user) {create(:user)}
  let!(:team) {create :team}
  let!(:invite) {TeamInvite.create(user: user, team: team)}

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
end