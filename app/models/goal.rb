class Goal < ActiveRecord::Base
  acts_as_votable

  validates :name, presence: true
  validates :amount, presence: true
  validates :balance_id, presence: true

  belongs_to :balance

  def self.achieved(team)
    where(balance: Balance.current(team)).where.not(achieved_on: nil).order("amount ASC")
  end

  def self.previous(team)
    where(balance: Balance.current(team)).where.not(achieved_on: nil).order("amount DESC").first || Goal.new(name: "N/A", amount: 0)
  end

  def self.next(team)
    where(balance: Balance.current(team)).where(achieved_on: nil).order("amount ASC").first || Goal.create(name: 'TBD', amount: Goal.previous(team).amount + 1000, balance: Balance.current(team), achieved_on: nil)
  end

  def achieved?
    achieved_on.present?
  end

  def achieve!
    touch(:achieved_on)
  end

end
