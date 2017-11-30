require 'rails_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

options = {js_errors: false, timeout: 30}
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end


RSpec.feature "Add a like", type: :feature do
  let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 100 }
  let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
  let(:activity) { Activity.create name: 'Helping with RSpec' }
  let(:user) { User.create name: 'Pascal', avatar_url: '/kabisa_lizard.png' }
  let(:user_2) { User.create name: 'Piet', avatar_url: '/kabisa_lizard.png' }
  let(:balance) { create :balance, :current }
  let!(:transaction) { Transaction.create id: 1, sender: user, receiver: user, activity: activity, amount: 5, balance: balance}
  let!(:transaction_2) { Transaction.create id: 2, sender: user, receiver: user, activity: activity, amount: 10, balance: balance}
  let!(:liked) { transaction.liked_by user_2 }

  before do
    visit '/sign_in'
    click_link 'Log in with Google'
    expect(current_path).to eql('/')
    find('button.close-welcome').click
  end

  context 'User likes transaction' do

    it 'displays who liked', js: true do
      find("#like-#{transaction.id}").click
      within "#number-of-likes-#{transaction.id}" do
        expect(page).to have_content("and 1 others")
      end
    end
  end

  context 'User unlikes transaction' do
    it 'displays who liked', js: true do
      find("#like-#{transaction.id}").click
      find("#unlike-#{transaction.id}").click
      within "#number-of-likes-#{transaction.id}" do
        expect(page).to have_content("+1 ₭ by Piet")
      end
    end
  end
end