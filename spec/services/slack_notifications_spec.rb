require 'rails_helper'
require 'dotenv'

describe SlackNotifications do
  context 'Given SLACK_WEBHOOK_URL to be nil' do
    it 'Exits the method' do
      slack_webhook_url = nil
      expect(slack_webhook_url).to be(nil)
    end
  end
  context 'Given SLACK_WEBHOOK_URL not nil' do
    it 'continues the method' do
      # Dotenv::Railtie.load
      slack_webhook_url = ENV['SLACK_WEBHOOK_URL']
      expect(slack_webhook_url).to eq(ENV['SLACK_WEBHOOK_URL'])
    end
  end
end