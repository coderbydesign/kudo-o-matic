class Activity < ActiveRecord::Base

  has_many :transactions
  acts_as_votable
  def to_s
    name
  end

end
