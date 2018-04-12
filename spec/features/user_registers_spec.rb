require 'rails_helper'

feature 'User registers' do
  scenario 'with valid details' do
    visit '/sign_up'

    fill_in 'Name', with: 'Ruud'
    fill_in 'Email', with: 'tester@example.tld'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_button 'Sign up'
    expect(current_path).to eq '/users/sign_in'
  end
end