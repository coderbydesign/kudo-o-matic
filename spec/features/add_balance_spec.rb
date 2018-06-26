# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Add a new balance', type: :feature do
  let!(:user) { create :user }
  let!(:team) { create :team }
  let!(:invites_before) { TeamInvite.count }
  let!(:balance_count) { team.balances.count }

  before do
    team.add_member(user, true)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'validpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')

    click_link 'team-manage-button-desktop'
    expect(current_path).to eql('/kabisa/manage')

    click_link 'Manage balances'
    expect(current_path).to eql('/kabisa/manage/balances')

    click_link 'Create new balance'
    expect(current_path).to eql('/kabisa/manage/balances/new')
  end

  context 'Successfully created a balance' do
    before do
      fill_in 'balance_name', with: '2018'
      click_button 'Create balance'
      expect(current_path).to eql("/kabisa/manage/balances/#{Balance.last.id}")
    end

    it 'creates a balance' do
      expect(team.balances.count).to_not eql(balance_count)
    end
  end
end
