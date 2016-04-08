require "test_helper"

class AddTransactionTest < Capybara::Rails::TestCase
  test "add a new transaction" do
    visit new_transaction_path

    fill_in 'transaction_sender', with: 'William'
    fill_in 'transaction_receiver', with: 'Harry'
    fill_in 'transaction_activity', with: 'helping me out'
    fill_in 'transaction_amount', with: '99'
    click_button 'Give kudos'

    assert_equal dashboard_path, current_location

    within '#most-recent' do
      assert_content page, "99 ₭ from WILLIAM to HARRY for HELPING ME OUT"
    end

    within '#progress-label' do
      # 1342 + 99 = 1441
      assert_content page, "1.441 ₭"
    end
  end
end

