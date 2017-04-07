class Balance < ActiveRecord::Base
  has_many :transactions

  scope :balances, -> { where(current: false).order("created_at DESC") }

  def self.current
    where(current: true).order("created_at DESC").first
  end

  def add(amount)
    amount = amount.to_i unless amount.is_a?(Integer)
    increment!(:amount, amount)
  end

  def last_transaction
    transactions.order("created_at DESC").first
  end
end
