class KudosDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  layout 'mailer'
  default from: ENV['MAIL_USERNAME']

  def confirmation_instructions(record, token, opts={})
    add_logo_attachment
    super
  end

  def reset_password_instructions(record, token, opts={})
    add_logo_attachment
    super
  end

  def unlock_instructions(record, token, opts={})
    add_logo_attachment
    super
  end

  private

  def add_logo_attachment
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/kudo-o-matic-white-mail.png")
  end
end