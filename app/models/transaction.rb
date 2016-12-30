class Transaction < ActiveRecord::Base
  #validates :amount, numericality: { greater_than_or_equal_to: 1 }
  acts_as_votable
  belongs_to :balance
  belongs_to :activity
  belongs_to :sender,   class_name: "User"
  belongs_to :receiver, class_name: "User"

  delegate :name, to: :sender,   prefix: true
  delegate :name, to: :receiver, prefix: true
  delegate :name, to: :activity, prefix: true

  GUIDELINES =
    [['BlogPost Inbound', 40],
    ['Blog tech', 20],
    ['Pizza Session', 40],
    ['Lunch&Learn', 20],
    ['Be a great help for someone', 10],
    ['Call for Proposal for a conference', 20],
    ['Speak at a conference', 100],
    ['Project RefCase', 40],
    ['Visit conference', 20],
    ['Score a project of >50 hours', 250],
    ['Score consultancy project', 50],
    ['New colleague', 100],
    ['Introduce a new potential client (ZOHO)', 40],
    ['Start a meeting in time', 1],
    ['Margin / month super (>=12% ROS)', 500],
    ['Margin / month fine (>= 8% ROS <=12%)', 200],
    ['Margin / month reasonable (>= 4% ROS <=8%)', 100],
    ['Turnover / month super (>= 220k)', 500],
    ['Turnover / month fine (>= 200k; <= 220k)', 200],
    ['Turnover / month reasonable (>= 180k <= 200k)', 100],
    ['Get a client satisfaction score', 40],
    ['Get a great client satisfaction score', 80],
    ['Get a client quote for the website', 100],
    ['Organize event for external relations (workshop, coderetreat)', 50]]

  def self.guidelines_between(from, to)
    gl = []
    GUIDELINES.each do |g|
      gl.push g[0] if g[1] >=from and g[1] <=to
      gl.push g[1] if g[1] >=from and g[1] <=to

    end
    gl
  end

end
