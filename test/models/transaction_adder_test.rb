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

  end

end
