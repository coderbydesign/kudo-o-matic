# frozen_string_literal: true

class Api::V2::TeamInvitesController < Api::V2::ApiController
  def update
    invite_id = params[:id]
    accept = params['accept']
    @invite = api_user.team_invites.open.find(invite_id)
    if accept
      @invite.accept
      render 'api/v2/teams/accepted', status: :ok
    else
      @invite.decline
      render 'api/v2/teams/declined', status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render json: { 'errors': [
      {
        title: 'Expired invite',
        detail: 'This invite does not exist or has expired'
      }
    ] }
  end
end
