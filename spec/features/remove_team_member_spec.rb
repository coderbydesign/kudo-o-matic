# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Remove a team member', type: :feature do
  let!(:user) {create :user}
  let!(:user2) {create :user, name: 'Henk', email: 'henk@example.com'}
  let(:team) {create :team}

  before do
    team.add_member(user, true)
    team.add_member(user2)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'validpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')

    click_link 'team-manage-button-desktop'
    expect(current_path).to eql('/kabisa/manage')

    click_link 'Manage members'
    expect(current_path).to eql('/kabisa/manage/members')
  end

  context 'clicking the Remove link' do
    before do
      membership = TeamMember.where(team_id: team.id).last
      click_link "rm-#{membership.id}"
      expect(current_path).to eql('/kabisa/manage/members')
    end

    it 'removes the user from the team' do
      # Remaining members should be current_user and company user
      expect(team.memberships.count).to eql(2)
    end
  end
end
