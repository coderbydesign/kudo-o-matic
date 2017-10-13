class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted? && !@user.deactivated?
      sign_in_and_redirect @user, event: :authentication
    elsif @user.deactivated?
      flash[:notice] = 'Your account is deactivated'
      redirect_back(fallback_location: new_user_session_path)
    else
      redirect_back(fallback_location: new_user_session_path)
    end
  end
end
