class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_current_team
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new_session_path(scope)
    new_user_session_path
  end

  def set_current_team
    @current_team = session[:current_team]
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
