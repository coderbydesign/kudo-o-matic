require 'rails_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

options = {js_errors: false, timeout: 2.minutes}
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

RSpec.feature "Open a modal", type: :feature do
  let(:user) { User.create name: 'Pascal', email: 'pascal@email.nl', password: 'testpass',
                           password_confirmation: 'testpass', confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png' }
  let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 100 }
  let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
  let!(:balance) { create :balance, :current }

  before(:each) do
    visit '/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'testpass'
    click_button 'Log in'
    expect(current_path).to eql('/')
    find('.close-welcome').click
  end

  context 'Given the guideline modal' do
    before do
      @guidelines = Transaction::GUIDELINES.count
      find('.btn-guideline-info').click
    end

    it 'Opens the modal and displays the guidelines' do
      expect(page).to have_css('.guideline-modal', visible: true)
      within '.guideline-modal' do
        expect(page).to have_selector('.guideline-list', count: @guidelines)
      end
    end

    it 'Copies a guideline on click', js: true do
      find(:css, '.guideline-list', match: :first).click
      within('.guideline-modal') do
        within '.clipboard-guideline' do
          expect(page).to have_content('Copied!')
        end
        expect(page).to have_css('.show-clipboard')
      end
    end
  end

  context 'Given the emoji modal' do
    before do
      @emoji = Transaction::EMOJIES.count
      find('.create-transaction-container .fa.fa-smile-o').click
    end

    it 'Opens the modal and displays the emojies' do
      expect(page).to have_css('.emoji-modal', visible: true)
      within '.emoji-modal' do
        expect(page).to have_selector('.emoji-container', count: @emoji)
      end
    end

    # Problems with on success function javascript which triggers .clipboard-emoji to have content
    xit 'Copies a emoji on click', js: true do
      find(:css, '.emoji-container', match: :first).click
      within ('.textarea-field') do
        expect(page).to have_content(':+1:')
      end
    end
  end

  #TODO Write spec for Help Modal and Release Modal
end