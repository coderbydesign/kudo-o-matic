require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

adminUser = User.new
adminUser.email = 'admin@example.com'
adminUser.name = 'John Doe'
adminUser.password = 'password'
adminUser.password_confirmation = 'password'
adminUser.admin = true
adminUser.save!

teamUser = User.new
teamUser.email = 'ariejan@example.com'
teamUser.name = 'Ariejan de Vroom'
teamUser.password = 'password'
teamUser.password_confirmation = 'password'
teamUser.save!

team = Team.create(name: "Test Team")

team.add_member(adminUser, true)
team.add_member(teamUser)

GUIDELINES =
    [['Margin / month super (>=15% ROS)', 500],
     ['Turnover / month super (>= 350k)', 500],
     ['Score a project of >50 hours', 250],
     ['Margin / month fine (>= 10% ROS <=15%)', 200],
     ['Turnover / month fine (>= 300k; <= 350k)', 200],
     ['Get a client quote for the website', 100],
     ['Margin / month reasonable (>= 5% ROS <= 10%)', 100],
     ['New colleague', 100],
     ['Speak at a conference', 100],
     ['Turnover / month reasonable (>= 280k <= 300k)', 100],
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
     ['Be a special help for someone', 10],
     ['Be a quick help for someone', 5],
     ['Start a meeting in time', 1]]

guidelines = GUIDELINES.each do |g|
  Guideline.create(name: g[0], kudos: g[1], team: team)
end

activity = Activity.new(name: "testing the kudo app")
activity2 = Activity.new(name: "helping me with testing")
activity3 = Activity.new(name: "transaction with awesome image")

image = File.open(File.join(Rails.root,'app/assets/images/test-image.png'))

transaction = Transaction.create(sender: adminUser, receiver: teamUser, activity: activity, amount: 10, team: team, balance: Balance.current(team))
transaction2 = Transaction.create(sender: teamUser, receiver: teamUser, activity: activity2, amount: 50, team: team, balance: Balance.current(team))
transaction3 = Transaction.create(sender: teamUser, receiver: teamUser, activity: activity3, amount: 1, image: image, team: team, balance: Balance.current(team))

teamInvitePending = TeamInvite.create(team: team, email: 'test@example.com', sent_at: DateTime.now)
teamInviteDeclined = TeamInvite.create(team: team, email: 'test2@example.com', sent_at: DateTime.now, declined_at: DateTime.now)

