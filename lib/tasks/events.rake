
namespace :events do
  desc "Rake task to send Slack reminder"
  task :fetch => :environment do
    puts "Send notification at #{Time.now}"
    Transaction.send_whenever
    @user = User.where.not(email:"")
    ReminderMailer.new_reminder(@user)
  end
end