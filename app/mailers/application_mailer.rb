class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('GMAIL_USERNAME', 'example@mail.com')
  layout 'mailer'
  add_template_helper(TransactionsHelper)
end

