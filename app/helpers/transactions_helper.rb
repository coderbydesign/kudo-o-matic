module TransactionsHelper
  include ActionView::Helpers::TextHelper

  def render_activity(transaction, markdown)
    escapeHTML = html_escape(transaction.activity_name_feed)
    autolink = auto_link(escapeHTML, :all, target: '_blank')
    markdown.render(autolink).html_safe
  end

  def display_likes(transaction)
    likes = transaction.votes_for.voters.first(1).collect { |user| user }.to_sentence
    list_likers(transaction, likes)
  end

  def tooltip_other_likes(transaction)
    list_others_tooltip(transaction)
  end

  def percentage_next_goal(team)
    number = ((Balance.current(team).amount.to_f - Goal.previous(team).amount.to_f) / (Goal.next(team).amount.to_f - Goal.previous(team).amount.to_f)) * 100
    helper.number_to_percentage(number, precision: 0)
  end
  
  def kudos_to_next_goal(team)
    Goal.next(team).amount - Balance.current(team).amount
  end

  private

  def list_likers(transaction, likes)
    if number_of_likes(transaction) == 1
      "+1 ₭ by #{likes}"
    elsif number_of_likes(transaction) > 1
      "+#{number_of_likes(transaction)} ₭ by #{likes} and #{number_of_likes(transaction) - 1} others"
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

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end
end
