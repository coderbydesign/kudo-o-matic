class CustomDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  layout 'mailer'

  def confirmation_instructions(record, token, opts={})
    super
  end
end