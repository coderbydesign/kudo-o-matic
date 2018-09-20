# == Schema Information
#
# Table name: balances
#
#  id         :integer          not null, primary key
#  name       :string
#  current    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#

class Balance < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :team
  has_many :transactions
  has_many :goals

  attr_accessor :make_balance_active_checkbox

  scope :balances, -> { where(current: false).order("created_at DESC") }

  def self.current(team)
    where(current: true).where(team_id: team).order("created_at DESC").first
  end

  def last_transaction
    transactions.order("created_at DESC").first
  end

  def self.likes(balance)
    Transaction.joins("INNER JOIN votes on votes.votable_id = transactions.id and votable_type='Transaction'").where("balance_id=#{balance.id}").count
  end

  def amount
    Transaction.where(balance: self).sum(:amount) + Balance.likes(self)
  end

  def self.time_left
    current = Time.new.at_end_of_day
    expire = Time.new.at_end_of_year
    days_left = (expire - current).to_i / (24 * 60 * 60)
    "#{days_left} days left"
  end


end
