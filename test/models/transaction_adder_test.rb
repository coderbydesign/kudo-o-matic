require "test_helper"

class TransactionAdderTest < ActiveSupport::TestCase

  def params(opts = {})
    {
      sender: 'William',
      receiver: 'Harry',
      amount: 42,
      activity: 'being a good brother'
    }.merge(opts)
  end

  def test_add_transaction
    transaction = TransactionAdder.create(params)

    assert transaction.sender.is_a?(User)
    assert_equal "William", transaction.sender.name

    assert transaction.receiver.is_a?(User)
    assert_equal "Harry", transaction.receiver.name

    assert transaction.activity.is_a?(Activity)
    assert_equal "being a good brother", transaction.activity.name

    assert_equal 42, transaction.amount

    assert_equal balances(:current), transaction.balance
  end

  def test_balance_accumulation
    assert_equal 1342, Balance.current.amount
    transaction = TransactionAdder.create(params)
    assert_equal 1342 + 42, Balance.current.amount
  end

  def test_goal_reacher
    GoalReacher.expects(:check!).once
    TransactionAdder.create(params)
  end
end
