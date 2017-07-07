class Balance < ActiveRecord::Base
  has_many :transactions

  scope :balances, -> { where(current: false).order("created_at DESC") }

  def self.current
    where(current: true).order("created_at DESC").first
  end

  def last_transaction
    transactions.order("created_at DESC").first
  end

  def self.likes(balance)
    Transaction.joins("INNER JOIN votes on votes.votable_id = transactions.id and votable_type='Transaction'").where("balance_id=#{balance.id}").count
  end

  def amount
    Transaction.where(balance: self).sum(:amount) + Balance.likes(Balance.current)
  end

  def self.time_left
    current = Time.new.at_end_of_day
    expire = Time.new.at_end_of_year
    days_left = (expire - current).to_i / (24 * 60 * 60)
    "#{days_left} days left"
  end
end
