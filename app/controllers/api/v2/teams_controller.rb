class Api::V2::TeamsController < Api::V2::ApiController

  def me
    @teams = api_user.teams.order(:created_at)
    @invites = api_user.team_invites
  end

end