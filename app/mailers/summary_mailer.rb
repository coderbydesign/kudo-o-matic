class SummaryMailer < ApplicationMailer
  def self.new_summary
    return if Rails.env == 'test' || ENV['MAIL_USERNAME'] == nil

    User.where.not(email: '').where(mail_notifications: true).each do |user|
      summary_email(user).deliver!
    end
  end

  def summary_email(user)
    @user = user
    @transactions = Transaction.where('created_at >= ?', 1.week.ago).sort_by(&:kudos_amount).reverse.first(7)

    @markdown = Redcarpet::Markdown.new(MdEmoji::Render, no_intra_emphasis: true)

    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/kudo-o-matic-white-mail.png")
    attachments.inline['no-picture.jpg'] = File.read("#{Rails.root}/public/no-picture-icon.jpg")

    mail(to: user.email, subject: 'Weekly ₭udo summary!')
  end
end