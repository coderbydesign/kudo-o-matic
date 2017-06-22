module TransactionsHelper
  include ActionView::Helpers::TextHelper

  def render_activity(transaction)
    escapteHTML = html_escape(transaction.activity_name_feed)
    autolink = auto_link(escapteHTML, :all, target: '_blank')
    @markdown.render(autolink).html_safe
  end
end
