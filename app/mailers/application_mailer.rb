class ApplicationMailer < ActionMailer::Base
  default from: ENV['GMAIL_USERNAME']
  layout 'mailer'
  add_template_helper(TransactionsHelper)
end

