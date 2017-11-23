class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted? && !@user.deactivated?
      sign_in_and_redirect @user, event: :authentication
    elsif @user.deactivated?
      flash[:notice] = 'Your account is deactivated'
      redirect_back(fallback_location: new_user_session_path)
    else
      redirect_back(fallback_location: new_user_session_path)
    end
  end

  def slack
    User.transaction do
      data = request.env['omniauth.auth']

      info = data['info']
      slack_id = info['user_id']
      slack_username = info['user']

      profile = data['extra']['user_info']['user']['profile']
      slack_name = profile['display_name'].present? ? profile['display_name'] : profile['real_name']

      flash[:notice] = "Successfully #{current_user.slack_id.blank? ? 'connected to Slack!' : 'updated your Slack display name!'}"

      current_user.update(slack_id: slack_id, slack_username: slack_username, slack_name: slack_name)
    end

    redirect_to settings_path
  end
end
