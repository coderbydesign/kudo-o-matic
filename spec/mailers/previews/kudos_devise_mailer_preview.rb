# Preview all emails at http://localhost:3000/rails/mailers/custom_devise_mailer
class KudosDeviseMailerPreview < ActionMailer::Preview

  def confirmation_instructions
    KudosDeviseMailer.confirmation_instructions(User.first, "faketoken", {})
  end

  def reset_password_instructions
    KudosDeviseMailer.reset_password_instructions(User.first, "faketoken", {})
  end

  def unlock_instructions
    KudosDeviseMailer.unlock_instructions(User.first, "faketoken", {})
  end
end