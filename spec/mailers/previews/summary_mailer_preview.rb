# Preview all emails at http://localhost:3000/rails/mailers/summary_mailer
class SummaryMailerPreview < ActionMailer::Preview
  def new_summary
    user = User.where.not(email: '').first
    team = Team.first

    SummaryMailer.summary_email(user, team)
  end
end
