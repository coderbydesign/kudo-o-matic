class FeedController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    request.format = :atom
    @transactions = Transaction.last(25)

    respond_to do |format|
      format.atom
    end
  end
end
