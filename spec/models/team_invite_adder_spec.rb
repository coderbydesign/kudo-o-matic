# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamInviteAdder, type: :model do
  describe '#create_from_email_list' do
    context 'with emails from non-members and non-invited users' do
      let!(:user) { create(:user) }
      let!(:user2) { create(:user, name: 'Henk', email: 'henk@example.com') }
      let!(:user3) { create(:user, name: 'Jan', email: 'jan@example.com') }
      let!(:user4) { create(:user, name: 'Rico', email: 'rico@example.com') }
      let!(:user5) { create(:user, name: 'Ariejan', email: 'ariejan@example.com') }
      let!(:team) { create :team }

      before do
        team.add_member(user)
        # This shows that both comma and semicolon delimiters work
        # It also shows that emails can be entered in different formats
        emails = 'henk@example.com, jan@example.com; "Rico" <rico@example.com>, Ariejan <ariejan@example.com>'
        TeamInviteAdder.create_from_email_list(emails, team)
      end

      it 'creates the invites' do
        expect(TeamInvite.count).to eq(4)
      end
    end

    context 'with email from a member' do
      let!(:user) { create(:user) }
      let!(:user2) { create(:user, name: 'Henk', email: 'henk@example.com') }
      let!(:team) { create :team }
      let(:invites_before) { TeamInvite.count }

      before do
        team.add_member(user)
        team.add_member(user2)
        emails = 'henk@example.com'
        TeamInviteAdder.create_from_email_list(emails, team)
      end

      it 'does not create another invite' do
        expect(TeamInvite.count).to eq(invites_before)
      end
    end

    context 'with email from a invited user' do
      let!(:user) { create(:user) }
      let!(:user2) { create(:user, name: 'Henk', email: 'henk@example.com') }
      let!(:team) { create :team }
      let!(:invite) { TeamInvite.create(user: user2, team: team) }
      let(:invites_before) { TeamInvite.count }

      before do
        team.add_member(user)
        emails = 'henk@example.com'
        TeamInviteAdder.create_from_email_list(emails, team)
      end

      it 'does not create another invite' do
        expect(TeamInvite.count).to eq(invites_before)
      end
    end
  end
end
