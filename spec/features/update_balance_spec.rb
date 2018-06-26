# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Update a balance', type: :feature do
  let!(:user) { create :user }
  let(:team) { create :team }
  let!(:invites_before) { TeamInvite.count }
  let!(:balance_count) { team.balances.count }
  let!(:balance) { team.balances.last }

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

    click_link 'My first balance'
    expect(current_path).to eql("/kabisa/manage/balances/#{balance.id}")

    click_link 'edit-balance'
    expect(current_path).to eql("/kabisa/manage/balances/#{balance.id}/edit")
  end

  context 'Successfully updated a balance' do
    before do
      fill_in 'balance_name', with: 'My second balance'
      click_button 'Update balance'
      expect(current_path).to eql('/kabisa/manage/balances')
    end

    it 'updates a balance' do
      expect(Balance.last.name).to eql('My second balance')
    end
  end
end
