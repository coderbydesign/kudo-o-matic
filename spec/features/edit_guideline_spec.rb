# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Remove a guideline', type: :feature do
  let(:user) do
    User.create name: 'Pascal', email: 'pascal@email.com', password: 'testpass',
                password_confirmation: 'testpass', confirmed_at: Time.now,
                avatar_url: '/kabisa_lizard.png', restricted: false
  end
  let!(:user_unauthorized) { create(:user)}
  let!(:team) { create(:team) }
  let!(:balance) { create :balance, current: :current, team_id: team.id }
  let!(:goal) { create(:goal) }
  let!(:guideline) { create :guideline, kudos: 5, team_id: team.id }
  let!(:guideline_name) { guideline.name }

  before do
    team.add_member(user, true)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'testpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')

    click_link 'Manage team'
    expect(current_path).to eql(manage_team_path(team: team))

    click_link 'Guidelines'
    expect(current_path).to eql(guidelines_path(team: team))

    click_link 'Edit'
    expect(current_path).to eql(edit_guideline_path(id: guideline.id, team: team))
  end

  context 'Successfully edited a guideline' do
    before do
      fill_in 'guideline_name', with: 'This is an edited guideline'
      click_button 'Update guideline'
      expect(current_path).to eql(guidelines_path(team: team))
    end

    it 'edited a guideline' do
      expect(Guideline.last.name).to_not eql(guideline_name)
    end
  end

end
