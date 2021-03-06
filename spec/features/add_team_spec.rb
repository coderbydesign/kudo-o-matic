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

  context 'Successfully created team' do
    before do
      fill_in 'team_name', with: 'Kabisa'
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

  context 'Unsuccessfully created team' do
    before do
      fill_in 'team_name', with: ''
      click_button 'create-team-button'
    end

    it 'does not create a new team' do
      expect(Team.count).to eq(@teams_before)
    end

    it 'does not create a balance and goals' do
      expect(Balance.count).to eq(0)
      expect(Goal.count).to eq(0)
    end

    it 'shows error messages' do
      expect(page).to have_content("Name can't be blank")
    end
  end
end
