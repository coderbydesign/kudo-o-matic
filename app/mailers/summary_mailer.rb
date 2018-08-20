class SummaryMailer < ApplicationMailer
  def self.new_summary
    return if Rails.env == 'test' || ENV['MAIL_USERNAME'].blank?

    Team.all.each do |t|
      t.users.where.not(email: '').where(deactivated_at: nil).each do |user|
        summary_email(user, t).deliver_later if user.summary_mail
      end
    end

  end

  def summary_email(user, team)
    @user = user
    @reached_goal = team.goals.where('achieved_on >= ?', 1.week.ago).last
    @transactions = team.transactions.where('created_at >= ?', 1.week.ago).sort_by(&:kudos_amount).reverse.first(7)
    @team = team

    @markdown = Redcarpet::Markdown.new(MdEmoji::Render, no_intra_emphasis: true)

    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/kudo-o-matic-white-mail.png")

    if @transactions.any? {|t| t.sender&.avatar_url.blank? || t.receiver&.avatar_url.blank?}
      attachments.inline['no-picture.jpg'] = File.read("#{Rails.root}/public/no-picture-icon.jpg")
    end

    mail(to: user.email, subject: 'Weekly ₭udo summary!')
  end
end
