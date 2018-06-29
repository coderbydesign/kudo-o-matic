class CallbacksController < ApplicationController

  def slack
    TeamMember.transaction do
      puts request.body
      data = request.env['omniauth.auth']

      info = data['info']
      slack_id = info['user_id']
      slack_username = info['user']

      profile = data['extra']['user_info']['user']['profile']
      slack_name = profile['display_name'].present? ? profile['display_name'] : profile['real_name']

      flash[:notice] = "Successfully #{current_team.membership_of(current_user).slack_id.blank? ? 'connected to Slack!' : 'updated your Slack display name!'}"

      current_membership = current_team.membership_of(current_user)
      current_membership.update(slack_id: slack_id, slack_username: slack_username, slack_name: slack_name)
    end

    redirect_to settings_path
  end
end