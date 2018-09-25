# Preview all emails at http://localhost:3000/rails/mailers/custom_devise_mailer
class CustomDeviseMailer < ActionMailer::Preview

  def confirmation_instructions
    CustomDeviseMailer.confirmation_instructions(User.first, "faketoken", {})
  end
end