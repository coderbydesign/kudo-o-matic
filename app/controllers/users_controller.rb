# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, except: %i[autocomplete_search]
  before_action :set_team_and_check_membership, only: %i[autocomplete_search]

  def edit; end

  def view_data
    @transactions_count = Transaction.all_for_user(@user).count
    @votes_count = @user.votes.count
    @exports = @user.exports
  end

  def view_transactions
    @transactions = TransactionDecorator.decorate_collection(
      @user.all_transactions.page(params[:page]).per(20)
    )
  end

  def view_likes
    @likes = @user.votes.page(params[:page]).per(20)
  end

  def export_json
    ExportService.instance.start_new_export(@user, @current_team, :json)
    render template: 'users/export_data', locals: { dataformat: 'JSON' }
  end

  def export_xml
    ExportService.instance.start_new_export(@user, @current_team, :xml)
    render template: 'users/export_data', locals: { dataformat: 'XML' }
  end

  def download_export
    export = Export.find_by_uuid!(params[:uuid])
    redirect_to export.zip.url
  rescue ActiveRecord::RecordNotFound
    render 'users/export_expired'
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
    @users = User.find_by_term(params[:term])
    render json: @users.map(&:name)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:transaction_received_mail, :goal_reached_mail, :summary_mail,
                                 :restricted)
  end

end
