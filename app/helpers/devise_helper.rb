module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="message-container show-message" role="alert">
      <div class="error-message margin-bottom">
        <span class="message">
          <ul>
            #{messages}
          </ul>
        </span>
      </div>
    </div>
    HTML

    html.html_safe
  end

  def unconfirmed_access_hours_left(user)
    expiration = user.confirmation_sent_at + Devise.allow_unconfirmed_access_for
    ((expiration - Time.now) / 1.hour).round
  end
end