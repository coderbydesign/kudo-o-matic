# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Invite a user', type: :feature do
  let(:user) { create :user }
  let(:user2) { create :user, name:'Henk', email:'henk@example.com' }
  let(:team) { create :team }
  let!(:invites_before) { TeamInvite.count }

  before do
    team.add_member(user, true)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'validpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')

    click_link 'Manage Kabisa'
    expect(current_path).to eql('/kabisa/manage')
  end

  context 'with a valid emailaddress' do
    before do
      fill_in 'email-invite-textarea', with: user2.email
      click_button 'Send invites'
      expect(current_path).to eql('/kabisa/manage')
    end

    it 'creates an invite' do
      expect(TeamInvite.count).not_to eql(invites_before)
    end
  end

  context 'with a invalid emailaddress' do
    before do
      fill_in 'email-invite-textarea', with: 'novalidemail'
      click_button 'Send invites'
      expect(current_path).to eql('/kabisa/manage/invite')
    end

    it 'does not create an invite' do
      expect(TeamInvite.count).to eql(invites_before)
    end
  end
end
