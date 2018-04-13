require 'rails_helper'

RSpec.feature 'Register', type: :feature do
  scenario 'User signs up' do
    visit '/sign_up'

    fill_in 'Name', with: 'Ruud'
    fill_in 'Email', with: 'tester@example.tld'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_button 'Sign up'
    expect(current_path).to eq user_session_path
  end
end