# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Update a team', type: :feature do
  let(:user) { create :user }
  let(:team) { create :team }

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

  context 'Successfully updated team' do
    before do
      fill_in 'name', with: 'Asibak'
      fill_in 'general_info', with: 'Some new info'
      click_button 'update-team-button'
    end

    it 'updates the fields' do
      expect(Team.find(team.id).name).to eq('Asibak')
      expect(Team.find(team.id).general_info).to eq('Some new info')
    end

    it 'shows success message' do
      expect(page).to have_content("Successfully updated team!")
    end
  end

  context 'Unsuccessfully updated team' do
    before do
      fill_in 'name', with: ''
      fill_in 'general_info', with: 'Some new info'
      click_button 'update-team-button'
    end

    it 'does not update the fields' do
      expect(Team.find(team.id).name).to eq(team.name)
      expect(Team.find(team.id).general_info).to eq(team.general_info)
    end

    it 'shows error message' do
      expect(page).to have_content("Name can't be blank")
    end
  end

end
