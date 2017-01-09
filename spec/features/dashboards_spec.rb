require 'rails_helper'

RSpec.feature "Dashboard", type: :feature do
  let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 500 }
  let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }

  let(:balance) { create :balance, :current, amount: 1000 }
  let(:sender) { create :sender, name: "Harry", avatar_url: "http://someimage" }
  let(:receiver) { create :sender, name: "William", avatar_url: "http://someimage"}
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
      expect(page).to have_content("42 ₭ Harry William less than a minute ago writing a blog post")
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

  context 'non-personal-kudos' do
    it('displays the group but does not create an new user') do
      @users_before = User.count
      visit '/'
      fill_in 'transaction_receiver', with: 'My awsome colleagues'
      fill_in 'transaction_activity', with: 'Helping me solve this puzzle'
      fill_in 'transaction_amount', with: '20'
      click_button 'Give ₭udos'
      expect(User.count).to eq(@users_before)
      expect(page).to have_css('.receivername', text: 'My awsome colleagues')
      expect(page).to have_css('.activityname', text: 'helping me solve this puzzle')
    end
  end
end
