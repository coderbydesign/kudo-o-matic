module TransactionsHelper
  include ActionView::Helpers::TextHelper

  def render_activity(transaction)
    escapteHTML = html_escape(transaction.activity_name_feed)
    autolink = auto_link(escapteHTML, :all, target: '_blank')
    @markdown.render(autolink).html_safe

  def display_likes(transaction)
    likes = transaction.votes_for.voters.first(1).collect { |user| user }.to_sentence
    list_likers(transaction, likes)
  end

  def tooltip_other_likes(transaction)
    list_others_tooltip(transaction)
  end

  private

  def list_likers(transaction, likes)
    if number_of_likes(transaction) == 1
      "Liked by #{likes}"
    elsif number_of_likes(transaction) > 1
      "Liked by #{likes} and #{number_of_likes(transaction) - 1} others"
    end
  end

  def list_others_tooltip(transaction)
    if number_of_likes(transaction) > 5 # more than 4 likes
      "and #{number_of_likes(transaction) - 5} others"
    end
  end

  def number_of_likes(transaction)
    transaction.get_upvotes.size
  end
end
