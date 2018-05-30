# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Add a team', type: :feature do
  let(:user) { create :user }

  before do
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'validpass'
    click_button 'Log in'

    expect(current_path).to eql('/')

    click_link 'create-new-team-button'
    expect(current_path).to eql('/teams/new')

    @teams_before = Team.count
  end

  context 'Succesfully created team' do
    before do
      fill_in 'team_name', with: 'Kabisa'
      fill_in 'team_slug', with: 'kabisa'
      fill_in 'team_general_info', with: 'This is some basic general info'
      click_button 'create-team-button'
    end

    it 'creates and shows the new team' do
      expect(Team.count).to_not eq(@teams_before)
      expect(current_path).to eql('/kabisa')
    end

    it 'creates a balance and three goals for the team' do
      expect(Balance.count).to eq(1)
      expect(Goal.count).to eq(3)
    end

    it 'gives Kudos to the creator of the team' do
      expect(Transaction.find_by_receiver_id_and_team_id(user.id, Team.last.id)).to be_present
    end
  end
end
