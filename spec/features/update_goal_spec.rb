# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Update a goal', type: :feature do
  let!(:user) { create :user }
  let(:team) { create :team }
  let!(:invites_before) { TeamInvite.count }
  let!(:balance_count) { team.balances.count }
  let!(:balance) { team.balances.last }
  let!(:goal) { team.goals.find_by_name('First goal') }

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

    click_link 'First goal'
    expect(current_path).to eql(goal_path(team: team, id: goal.id))

    click_link 'edit-goal'
    expect(current_path).to eql(edit_goal_path(team: team, id: goal.id))
  end

  context 'Successfully updated a goal' do
    before do
      fill_in 'goal_name', with: 'My new goal'
      fill_in 'goal_amount', with: 3000
      click_button 'Update goal'
      expect(current_path).to eql("/kabisa/manage/goals/#{goal.id}")
    end

    it 'updates the goal' do
      updated_goal = team.goals.find_by_name('My new goal')
      expect(updated_goal).to be_present
      expect(updated_goal.amount).to eql(3000)
    end
  end
end
