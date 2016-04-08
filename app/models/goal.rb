class Goal < ActiveRecord::Base

  belongs_to :balance

  def self.previous
    where.not(achieved_on: nil).order("amount DESC").first || Goal.new(name: "N/A", amount: 0)
  end

  def self.next
    where(achieved_on: nil).order("amount ASC").first || Goal.new(name: "N/A", amount: 0)
  end

  def achieved?
    achieved_on.present?
  end

  def achieve!
    touch(:achieved_on)
  end

end
