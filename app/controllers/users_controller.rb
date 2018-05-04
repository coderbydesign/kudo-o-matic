# frozen_string_literal: true
class UsersController < ApplicationController

  before_action :set_user, except: %i[autocomplete_search]

  def edit; end

  def view_data
    @transactions_count = @user.transactions.count
    @likes_count = @user.votes.count
  end

  def view_transactions
    @transactions = @user.transactions.page(params[:page]).per(20)
  end

  def view_likes
    @likes = @user.votes.page(params[:page]).per(20)
  end

  def update
    if @user.update(user_params)
      redirect_to root_url
    else
      render action: 'edit'
    end
  end

  def resend_email_confirmation
    unless current_user.confirmed?
      current_user.send_reset_password_instructions
      flash[:success] = 'Email confirmation instructions have been sent'
    end
    redirect_to root_url
  end

  def autocomplete_search
    @users = User.order(:name).where('lower(name) like ?', "#{params[:term]}%".downcase).where(deactivated_at: nil)
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
