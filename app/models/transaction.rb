class Transaction < ActiveRecord::Base
  validates :amount, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999, message: 'is not correct. You cannot give negative ₭udos, or exceed over 1000' }
  validates :activity_name, presence: true, length: {minimum: 4}
  
  after_commit :send_slack_notification, unless: :skip_callbacks
  after_destroy :subtract_from_balance

  acts_as_votable
  belongs_to :balance
  belongs_to :activity
  belongs_to :sender,   class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  delegate :name, to: :sender,   prefix: true
  delegate :name, to: :receiver, prefix: true
  delegate :name, to: :activity, prefix: true

  GUIDELINES =
      [['Margin / month super (>=12% ROS)', 500],
       ['Turnover / month super (>= 220k)', 500],
       ['Score a project of >50 hours', 250],
       ['Margin / month fine (>= 8% ROS <=12%)', 200],
       ['Turnover / month fine (>= 200k; <= 220k)', 200],
       ['Get a client quote for the website', 100],
       ['Margin / month reasonable (>= 4% ROS <=8%)', 100],
       ['New colleague', 100],
       ['Speak at a conference', 100],
       ['Turnover / month reasonable (>= 180k <= 200k)', 100],
       ['Get a great client satisfaction score', 80],
       ['Organize event for external relations (workshop, coderetreat)', 50],
       ['Score consultancy project', 50],
       ['BlogPost Inbound', 40],
       ['Project RefCase', 40],
       ['Get a client satisfaction score', 40],
       ['Pizza Session', 40],
       ['Introduce a new potential client (ZOHO)', 40],
       ['Blog tech', 20],
       ['Call for Proposal for a conference', 20],
       ['Lunch&Learn', 20],
       ['Visit conference', 20],
       ['Be a great help for someone', 10],
       ['Start a meeting in time', 1]]

  def self.guidelines_between(from, to)
    gl = []
    GUIDELINES.each do |g|
      gl.push g if g[1] >= from && g[1] <= to
    end
    gl
  end

  def receiver_name_feed
    receiver.nil? ? activity.name.split('for:')[0].strip : receiver.name
  end

  def activity_name_feed
    receiver.nil? ? activity.name.split('for:')[1].strip : activity.name
  end

  def receiver_image
    receiver_id.nil? ? '/kabisa_lizard.png' : receiver.picture_url
  end

  def activity_name
    activity.try(:name)
  end

  def activity_name=(name)
    self.activity = Activity.find_or_create_by(name: name) if name.present?
  end

  def receiver_name
    receiver.try(:name)
  end

  def receiver_name=(name)
    self.receiver = User.find_by(name: name) if name.present?
  end

  def send_slack_notification
    SlackNotifications.new(self).send_new_transaction
  end

  def subtract_from_balance
    balance.update_attribute :amount, (balance.amount - amount)
  end
end
