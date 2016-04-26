require "test_helper"

class DashboardTest < Capybara::Rails::TestCase
  test "shows relevant information" do
    visit root_path

    within '.last-transactions' do
      assert_content page, "1.342 ₭ from HARRY to WILLIAM for WRITING A BLOG POST"
    end

    within '.previous-goal' do
      assert_content page, "TENNIS"
      assert_content page, "1.000 ₭"
    end

    within '.next-goal' do
      assert_content page, "KARTEN"
      assert_content page, "1.500 ₭"
    end

    within '.progress-label' do
      assert_content page, "1.342 ₭"
    end
  end
end
