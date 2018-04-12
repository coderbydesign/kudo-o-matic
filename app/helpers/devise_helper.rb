module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="message-container error-message margin-top">
      <span class="message">
        <ul>
          #{messages}
        </ul>
      </span>
    </div>
    HTML

    html.html_safe
  end
end