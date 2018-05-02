# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update view_data view_transactions view_votes]

  def edit; end

  def view_data
    @transactions_count = @user.transactions.count
    @votes_count = @user.votes.count
  end

  def view_transactions
    @transactions = @user.transactions.page(params[:page]).per(20)
  end

  def view_votes
    @votes = @user.votes.page(params[:page]).per(20)
  end

  def update
    if @user.update(user_params)
      redirect_to root_url
    else
      render action: 'edit'
    end
  end

  def autocomplete_search
    @users = User.order(:name).where('lower(name) like ?', "#{params[:term]}%".downcase)
                 .where(deactivated_at: nil).where(restricted: false)
    render json: @users.map(&:name)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:transaction_received_mail, :goal_reached_mail, :summary_mail)
  end
end
