# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Update a team', type: :feature do
  let(:user) { create :user }
  let(:team) { create :team, logo: File.new(Rails.root + 'spec/fixtures/images/rails.png') }

  before do
    team.add_member(user, true)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'validpass'
    click_button 'Log in'

    expect(current_path).to eql('/kabisa')

    click_link 'Manage team'
    expect(current_path).to eql(manage_team_path(team: team))
  end

  context 'Successfully updated team' do
    before do
      fill_in 'name', with: 'Asibak'
      click_button 'update-team-button'
    end

    it 'updates the fields' do
      expect(Team.find(team.id).name).to eq('Asibak')
    end

    it 'shows success message' do
      expect(page).to have_content("Successfully updated team!")
    end
  end

  context 'Unsuccessfully updated team' do
    before do
      fill_in 'name', with: ''
      click_button 'update-team-button'
    end

    it 'does not update the fields' do
      expect(Team.find(team.id).name).to eq(team.name)
    end

    it 'shows error message' do
      expect(page).to have_content("Name can't be blank")
    end
  end

  context 'Update a team with an invalid image' do
    before do
      team.logo = File.new(Rails.root + 'spec/fixtures/images/earth.gif')
      team.save
    end

    it 'should keep the old image' do
      expect(team.logo_file_name).to eql('rails.png')
    end
  end
end
