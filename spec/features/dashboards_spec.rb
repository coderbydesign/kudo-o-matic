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

  it "shows relevant information" do
    visit '/'

    within('.last-transactions') do
      expect(page).to have_content("42 ₭ from HARRY to WILLIAM for WRITING A BLOG POST")
    end

    within('.previous-goal') do
      expect(page).to have_content("PAINTING LESSONS")
      expect(page).to have_content("500 ₭")
    end

    within('.next-goal') do
      expect(page).to have_content("PAINTBALL")
      expect(page).to have_content("1.500 ₭")
    end

    within('.progress-label') do
      expect(page).to have_content("1.000 ₭")
    end
  end
end
