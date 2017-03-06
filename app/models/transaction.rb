# require 'rubygems'
require 'slack-notifier'

class Transaction < ActiveRecord::Base
  validates :amount, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999, message: 'is not correct. You cannot give negative ₭udos, or exceed over 1000' }
  validates :activity,  presence: true

  after_save :send_slack_notification

  acts_as_votable
  belongs_to :balance
  belongs_to :activity
  belongs_to :sender,   class_name: "User"
  belongs_to :receiver, class_name: "User"

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
      gl.push g if g[1] >=from and g[1] <=to
    end
    gl
  end

  def receiver_name
    receiver.nil? ? activity.name.split('for:')[0] : receiver.name
  end

  def activity_name
    receiver.nil? ? activity.name.split('for:')[1] : activity.name
  end

  def receiver_image
    receiver_id.nil? ? '/kabisa_lizard.png' : receiver.picture_url
  end

  def send_slack_notification
    # binding.pry

    notifier = Slack::Notifier.new ENV['WEBHOOK_URL']

    puts "Hello World! #{activity.inspect}"
    notifier.ping(
        channel: '#general',
        attachments: [
            {
                fallback: 'New transaction',
                color: '#B58342',
                pretext: '<!channel> A new kudo transaction has been made! <https://kudos.kabisa.io/|Click here> for more details',
                fields: [
                    {
                        title: 'Kudos given by',
                        value: self.sender.name,
                        short: true
                    },
                    {
                        title: 'Kudos given to',
                        value: self.receiver_name,
                        short: true
                    },
                    {
                        title: 'Kudos given for',
                        value: self.activity.name,
                        short: true
                    },
                    {
                        title: 'Amount of Kudos',
                        value: '₭ ' + self.amount.to_s,
                        short: true
                    }
                ],
                footer: 'Kabisa | Kudos Platform',
                footer_icon: 'https://photos-3.dropbox.com/t/2/AAD3sWb0ll55oVhXXfSbJ9SnyBxlQ_IjOyXfk9r6FaLhTQ/12/184449953/png/32x32/3/1487948400/0/2/Screenshot%202017-02-24%2011.39.01.png/EKWxh4wBGKSMBiAHKAc/DmTqNb9yqF7N7YMUBiSYhLHMpX24p5RmZeiuzRibDls?dl=0&size=1280x960&size_mode=3',
                ts: '1358878755.000001',


            }
        ]

    )

  end

end
