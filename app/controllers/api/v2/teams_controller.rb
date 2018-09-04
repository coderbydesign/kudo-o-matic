class Api::V2::TeamsController < Api::V2::ApiController

  def me
    @teams = api_user.teams.order(:created_at)
    @invites = api_user.open_invites
  end

end