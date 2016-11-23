class VotesController < ApplicationController
before_action :pollvote, :polllike
  def pollvote
    # TODO implement session authentication
    @goal = Goal.find(params[:id])
    @goal.liked_by current_user
    redirect_to root_path
  end
end