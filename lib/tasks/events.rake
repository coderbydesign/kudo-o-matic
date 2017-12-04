namespace :events do
  desc 'Rake task to send email summary'
  task email: :environment do
    SummaryMailer.new_summary
  end
end
