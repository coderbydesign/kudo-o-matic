# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Invite a user', type: :feature do
  let!(:user) { create :user }
  let!(:user2) { create :user, name:'Henk', email:'henk@example.com' }
  let!(:user3) { create(:user, name: 'Jan', email: 'jan@example.com') }
  let!(:user4) { create(:user, name: 'Rico', email: 'rico@example.com') }
  let!(:user5) { create(:user, name: 'Ariejan', email: 'ariejan@example.com') }
  let(:team) { create :team }
  let!(:invites_before) { TeamInvite.count }

  before do
    team.add_member(user, true)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'validpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')

    click_link 'Invite people'
    expect(current_path).to eql(manage_invites_path(team: team))
  end

  context 'with a valid emailaddress' do
    before do
      emails = 'henk@example.com, jan@example.com; "Rico" <rico@example.com>, Ariejan <ariejan@example.com>'
      fill_in 'email-invite-textarea', with: emails
      click_button 'Send invites'
      expect(current_path).to eql('/kabisa/manage/invites')
    end

    it 'creates an invite' do
      expect(TeamInvite.count).to eql(4)
    end
  end

  context 'with a invalid emailaddress' do
    before do
      fill_in 'email-invite-textarea', with: 'novalidemail'
      click_button 'Send invites'
      expect(current_path).to eql('/kabisa/manage/invites')
    end

    it 'does not create an invite' do
      expect(TeamInvite.count).to eql(invites_before)
    end
  end
end
