require 'rails_helper'

RSpec.feature 'Register', type: :feature do
  let!(:balance) { create :balance, :current}

  scenario 'User signs up' do
    visit '/sign_up'

    fill_in 'user_name', with: 'Ruud'
    fill_in 'user_email', with: 'tester@example.tld'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'

    click_button 'Sign up'
    expect(current_path).to eq root_path
  end
end