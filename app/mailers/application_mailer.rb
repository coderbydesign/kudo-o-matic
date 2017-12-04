class ApplicationMailer < ActionMailer::Base
  default from: Rails.env == 'test' ? 'example@mail.com' : ENV['MAIL_USERNAME']
  layout 'mailer'

  add_template_helper(TransactionsHelper)
end

