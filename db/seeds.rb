require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

memberUser = User.new
memberUser.email = 'member@example.com'
memberUser.name = 'Team Member'
memberUser.password = 'password'
memberUser.password_confirmation = 'password'
memberUser.save!


adminUser = User.new
adminUser.email = 'admin@example.com'
adminUser.name = 'Team Admin'
adminUser.password = 'password'
adminUser.password_confirmation = 'password'
adminUser.admin = true
adminUser.save!

invitedUser = User.new
invitedUser.email = 'test@example.com'
invitedUser.name = 'Team User'
invitedUser.password = 'password'
invitedUser.password_confirmation = 'password'
invitedUser.save!

team = Team.create(name: "Test Team")

team.add_member(adminUser, true)

otherMembers = (1..10).each do |i|
  user = User.new
  user.email = "user-#{i}@example.com"
  user.name = "user-#{i}"
  user.password = 'password'
  user.password_confirmation = 'password'
  user.save!
  team.add_member(user)
end

guidelines = (1..50).each {|i| Guideline.create(name: "Guideline #{i}", kudos: i + 1, team: team)}

activity = Activity.new(name: "testing the kudo app")
activity2 = Activity.new(name: "helping me with testing")
activity3 = Activity.new(name: "transaction with awesome image")

image = File.open(File.join(Rails.root,'app/assets/images/test-image.png'))

transaction = Transaction.create(sender: adminUser, receiver: memberUser, activity: activity, amount: 10, team: team, balance: Balance.current(team))
transaction2 = Transaction.create(sender: memberUser, receiver: adminUser, activity: activity2, amount: 50, team: team, balance: Balance.current(team))
transaction3 = Transaction.create(sender: memberUser, receiver: adminUser, activity: activity3, amount: 1, image: image, team: team, balance: Balance.current(team))

teamInvitePending = TeamInvite.create(team: team, email: 'test@example.com', sent_at: DateTime.now)
teamInviteDeclined = TeamInvite.create(team: team, email: 'test2@example.com', sent_at: DateTime.now, declined_at: DateTime.now)

