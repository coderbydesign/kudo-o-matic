# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update view_data view_transactions
                                    view_votes export_data_to_json]

  def edit; end

  def view_data
    @transactions_count = Transaction.all_for_user(@user).count
    @votes_count = Vote.all_for_user(@user).count
  end

  def view_transactions
    @transactions = Transaction.all_for_user(@user).page(params[:page]).per(20)
  end

  def view_votes
    @votes = Vote.all_for_user(@user).page(params[:page]).per(20)
  end

  def export_data_to_json
    @transactions = Transaction.all_for_user(@user)
    @votes = Vote.all_for_user(@user)
    stream = render_to_string(template: 'users/data.json.jbuilder')
    send_data(stream, type: 'text/json', filename: "#{generate_filename}.json")
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

  def generate_filename
    "data_export_#{@user.name.underscore}_#{Time.now.strftime('%Y-%m-%d')}"
  end
end
