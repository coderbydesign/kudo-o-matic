# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_team

  def new_session_path(scope)
    new_user_session_path
  end

  def check_team_membership
    unless current_user.member_of?(current_team)
      render 'teams/access_denied', status: 403
    end
  end

  def current_team
    @current_team ||= request.headers['Team'] || Team.find_by_slug!(params[:tenant])
  end

  protected

  # Set custom fields for registration form
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:
        %i[name email password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys:
        %i[name email password password_confirmation])
  end

end
