# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, except: %i[autocomplete_search]

  def edit; end

  def view_data
    @transactions_count = @user.all_transactions.count
    @votes_count = @user.votes.count
  end

  def view_transactions
    @transactions = TransactionDecorator.decorate_collection(
      @user.all_transactions.page(params[:page]).per(20)
    )
  end

  def view_likes
    @likes = @user.votes.page(params[:page]).per(20)
  end

  def export
    @transactions = @user.all_transactions
    @votes = @user.votes

    respond_to do |format|
      format.json do
        json_data = render_user_data(:json)
        send_data(json_data, type: 'text/json; charset=UTF-8;', filename: "#{generate_filename}.json")
      end
      format.xml do
        xml_data = render_user_data(:xml)
        send_data(xml_data, type: 'text/xml; charset=UTF-8;', filename: "#{generate_filename}.xml")
      end
    end
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

  def generate_filename
    "data_export_#{@user.name.underscore}_#{Time.now.strftime('%Y-%m-%d')}"
  end

  def render_user_data(format)
    Rabl.render(@user, 'users/export',
                view_path: 'app/views',
                locals: {
                  transactions: @transactions,
                  votes: @votes
                },
                format: format)
  end
end
