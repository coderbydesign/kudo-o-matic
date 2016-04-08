require "test_helper"

class BalanceTest < ActiveSupport::TestCase

  def test_current
    assert_equal balances(:current), Balance.current
  end

  def test_last_transaction
    assert_equal transactions(:one), Balance.current.last_transaction
  end

  def test_add
    balance = Balance.current

    assert_equal 1342, balance.amount
    balance.add 42
    assert_equal 1342 + 42, balance.amount
  end

end
