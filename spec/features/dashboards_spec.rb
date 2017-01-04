require 'rails_helper'

RSpec.feature "Dashboard", type: :feature do
  let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 500 }
  let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }

  let(:balance) { create :balance, :current, amount: 1000 }
  let(:sender) { create :sender, name: "Harry" }
  let(:receiver) { create :sender, name: "William" }
  let(:activity) { create :activity, name: "writing a blog post" }

  let!(:transaction) {
    create :transaction, balance: balance,
      amount: 42,
      activity: activity,
      sender: sender,
      receiver: receiver
  }

  before do
    visit '/sign_in'
    click_link 'Sign in with Google Apps'
  end

  it "shows relevant information" do
    visit '/'

    within('.last-transactions') do
      expect(page).to have_content("42 ₭ Harry William writing a blog post")
    end

    within('.next-goal') do
      #expect(page).to have_content("PAINTBALL")
      expect(page).to have_content("1.500 ₭")
    end

    within('.jarwrapper') do
      bp = find(".loader")["data-balance-coins"]
      expect(bp).to eq('1000')
    end
  end
end
