class ApplicationMailer < ActionMailer::Base
  default from: Rails.env == 'test' || ENV['MAIL_USERNAME'].blank? ? 'example@mail.com' : ENV['MAIL_USERNAME']
  layout 'mailer'
  add_template_helper(TransactionsHelper)
  before_action :add_logo_attachment

  private

  def add_logo_attachment
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/kudo-o-matic-white-mail.png")
  end
end
