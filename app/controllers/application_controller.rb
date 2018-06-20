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

  def check_team_admin_rights
    unless current_user.admin_of?(current_team)
      redirect_to(dashboard_path(current_team.slug))
    end
  end

  def current_team
    @current_team ||= team_by_slug
  end

  protected

  # Set custom fields for registration form
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:
        %i[name email password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys:
        %i[name email password password_confirmation])
  end

  def team_by_slug
    if params[:team]
      Team.friendly.find(params[:team])
    else
      nil
    end
  end
end
