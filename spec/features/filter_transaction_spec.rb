require 'rails_helper'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {args: %w(headless disable-gpu)}
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome

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

RSpec.feature "Filter a transaction", type: :feature do
  let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 100 }
  let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
  let(:activity) { Activity.create name: 'Helping with RSpec' }
  let(:user) {
    User.create name: 'Pascal', email: 'test@email.com', password: 'testpass',
                password_confirmation: 'testpass', confirmed_at: Time.now,
                avatar_url: '/kabisa_lizard.png'
  }
  let(:team) { create :team }
  let(:balance) { Balance.current(team) }
  let!(:transaction) { Transaction.create sender: user, receiver: user, activity: activity, amount: 5, balance: balance, team_id: team.id}

  before do
    team.add_member(user)
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'testpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')
    find('.close-welcome').click
  end

  it 'Changes the filter text', js: true do
    first('.send-transactions').click
    within '.btn-filter' do
      expect(page).to have_content('My given transactions')
    end

  end
end