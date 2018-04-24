class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :view_data]

  def edit
  end

  def view_data
    @transactions_count = Transaction.all_for_user(@user).count
  end

  def view_transactions
    @transactions = Transaction.all_for_user(@user).page(params[:page]).per(20)
  end

  def update
    if @user.update(user_params)
      redirect_to root_url
    else
      render action: 'edit'
    end
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
