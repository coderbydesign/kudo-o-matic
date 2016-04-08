class Activity < ActiveRecord::Base

  has_many :transactions

  def to_s
    name
  end

end
