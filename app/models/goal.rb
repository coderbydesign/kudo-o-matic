class Goal < ActiveRecord::Base

  belongs_to :balance

  def self.previous
    where.not(achieved_on: nil).order("amount DESC").first
  end

  def self.next
    where(achieved_on: nil).order("amount ASC").first
  end

end
