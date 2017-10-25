
namespace :events do
  desc "Rake task to send Slack reminder"
  task fetch: :environment do
    Transaction.send_whenever
    SummaryMailer.new_reminder
  end
end