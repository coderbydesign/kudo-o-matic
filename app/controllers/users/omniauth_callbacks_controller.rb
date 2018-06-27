# frozen_string_literal: true

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
    team = Team.find(session[:omniauth_team_id])
    current_membership = team.membership_of(current_user)

    data = request.env['omniauth.auth']

    info = data['info']
    slack_id = info['user_id']
    slack_team_id = info['team_id']
    slack_username = info['user']

    bot = data['extra']['bot_info']
    bot_access_token = bot['bot_access_token']
    puts "TOKEN: #{bot_access_token}"

    profile = data['extra']['user_info']['user']['profile']
    slack_name = profile['display_name'].present? ? profile['display_name'] : profile['real_name']

    current_membership.update_attributes(slack_id: slack_id, slack_username: slack_username, slack_name: slack_name)

    team.update_attributes(slack_team_id: slack_team_id, slack_bot_access_token: bot_access_token)

    flash[:notice] = "Successfully #{current_user.slack_id.blank? ? 'connected to Slack!' : 'updated your Slack display name!'}"

    puts 'SAVING TEAM'

    redirect_to settings_path(team: team.slug)
  end
end
