# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Invite a user', type: :feature do
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
    @teams_before = Team.count
  end

end
