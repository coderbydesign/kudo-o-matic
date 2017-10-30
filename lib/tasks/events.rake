namespace :events do
  desc 'Rake task to send Slack reminder'
  task slack: :environment do
    Transaction.send_whenever
  end

  desc 'Rake task to send email summary'
  task email: :environment do
    SummaryMailer.new_summary
  end
end
