# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Accepting or declining an invite', type: :feature do
  let!(:user) {create :user}
  let!(:team) {create :team}
  let!(:invite) {TeamInvite.create(email: user.email, team: team)}

  before do
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'validpass'
    click_button 'Log in'

    expect(current_path).to eql('/')
  end

  context 'accepting the invite' do
    before do
      find('.invites').click_link("accept-#{invite.id}")
      expect(current_path).to eql('/kabisa')
    end

    it 'it sets the accepted_at date' do
      expect(TeamInvite.last.accepted_at).to_not be_nil
    end

    it 'adds the user to the team' do
      expect(TeamMember.find_by_user_id(user.id)).to be_present
    end
  end

  context 'declining the invite' do
    before do
      find('.invites').click_link("decline-#{invite.id}")
      expect(current_path).to eql('/')
    end

    it 'it sets the declined_at date' do
      expect(TeamInvite.last.declined_at).to_not be_nil
    end
  end
end
