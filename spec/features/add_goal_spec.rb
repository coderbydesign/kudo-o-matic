# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Add a new goal', type: :feature do
  let!(:user) { create :user }
  let!(:team) { create :team }
  let!(:invites_before) { TeamInvite.count }
  let!(:goal_count) { team.goals.count }
  let!(:balance) { Balance.last }

  before do
    team.add_member(user, true)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'validpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')

    click_link 'Manage team'
    expect(current_path).to eql(manage_team_path(team: team))

    click_link 'Balances and Goals'
    expect(current_path).to eql(balances_path(team: team))

    click_link 'Create new goal'
    expect(current_path).to eql('/kabisa/manage/goals/new')
  end

  context 'Successfully created a goal' do
    before do
      fill_in 'goal_name', with: '2018'
      fill_in 'goal_amount', with: 2000
      select('My first balance', from: 'goal_balance_id')
      click_button 'Create goal'
      expect(current_path).to eql("/kabisa/manage/goals/#{Goal.last.id}")
    end

    it 'creates a goal' do
      expect(team.goals.count).to_not eql(goal_count)
    end
  end
end
