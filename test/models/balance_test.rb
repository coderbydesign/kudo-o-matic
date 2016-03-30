require "test_helper"

class BalanceTest < ActiveSupport::TestCase

  def test_current
    assert_equal balances(:current), Balance.current
  end

  def test_current_amount
    assert_equal 1342, Balance.current_amount
  end

end
