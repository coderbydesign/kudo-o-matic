class ApplicationMailer < ActionMailer::Base
  if Rails.env == 'test'
    default from: 'example@mail.com'
  else
    default from: ENV['MAIL_USERNAME']
  end
  layout 'mailer'
  add_template_helper(TransactionsHelper)
end

