class Api::V2::TeamsController < Api::V2::ApiController

  def me
    @teams = api_user.teams
    @invites = api_user.team_invites.open
  end

end