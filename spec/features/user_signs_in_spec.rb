require 'rails_helper'

RSpec.feature 'Sign in', type: :feature do
  let(:user) do
    User.create name: 'Ruud', email: 'test@testdomain.com', password: 'testpass',
                password_confirmation: 'testpass', confirmed_at: Time.now
  end
  let!(:balance) { create :balance, :current }

  context 'With valid credentials' do
    before do
      visit '/sign_in'

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'testpass'

      click_button 'Log in'
    end

    it 'redirects the user to homepage' do
      expect(current_path).to eq root_path
    end
  end

  context 'Invalid submitted form' do

    before do
      visit '/sign_in'

      fill_in 'user_email', with: 'fake@unexisting.com'
      fill_in 'user_password', with: 'testpass'

      click_button 'Log in'
    end

    it 'redirects user to sign_in page' do
      expect(current_path).to eq new_user_session_path
    end
  end
end