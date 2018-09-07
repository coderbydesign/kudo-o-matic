require 'rails_helper'

describe 'Should work normally' do

  let!(:prev_goal) {create :goal, :achieved, name: 'Painting lessons', amount: 100}
  let!(:next_goal) {create :goal, name: 'Paintball', amount: 1500}
  let(:activity) {Activity.create name: 'Helping with RSpec'}
  let(:team) {create :team}
  let(:user) do
    User.create name: 'Pascal', email: 'pascal@email.com', password: 'testpass',
                password_confirmation: 'testpass', confirmed_at: Time.now,
                avatar_url: '/kabisa_lizard.png'
  end

  it 'should show the main page' do
    team.add_member(user)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'testpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')
    find('.close-welcome').click
  end
end