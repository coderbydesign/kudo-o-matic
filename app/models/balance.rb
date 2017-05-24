class Balance < ActiveRecord::Base
  has_many :transactions

  scope :balances, -> { where(current: false).order("created_at DESC") }

  def self.current
    where(current: true).order("created_at DESC").first
  end

  def last_transaction
    transactions.order("created_at DESC").first
  end

  def amount
    Transaction.where(balance: self).sum(:amount)
  end

  def self.time_left
    current = Time.new.at_end_of_day
    expire = Time.new.at_end_of_year
    days_left = (expire - current).to_i / (24 * 60 * 60)
    "#{days_left} days left"
  end
end
