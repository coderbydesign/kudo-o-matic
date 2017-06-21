
namespace :events do
  desc "Rake task to send Slack reminder"
  task :fetch => :environment do
    puts "Send notification at #{Time.now}"
    Transaction.send_whenever
  end
end