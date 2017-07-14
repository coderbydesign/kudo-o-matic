class ApplicationMailer < ActionMailer::Base
  if Rails.env != :test
    default from: ENV['GMAIL_USERNAME']
  else
    default from: 'example@mail.com'
  end
  layout 'mailer'
  add_template_helper(TransactionsHelper)
end

