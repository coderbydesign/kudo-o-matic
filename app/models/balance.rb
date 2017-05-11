class Balance < ActiveRecord::Base
  has_many :transactions

  scope :balances, -> { where(current: false).order("created_at DESC") }

  def self.current
    where(current: true).order("created_at DESC").first
  end

  def add(number_of_kudos)
    number_of_kudos = number_of_kudos.to_i unless number_of_kudos.is_a?(Integer)
    update(amount: amount + number_of_kudos)
  end

  def last_transaction
    transactions.order("created_at DESC").first
  end

  def amount
    Transaction.where(balance: self).sum(:amount)
  end

  def self.time_left
    current = Date.today
    year = Time.current.year
    expire = Date.parse("#{year}-12-31")
    "#{(expire - current).to_i} days left"
  end
end
