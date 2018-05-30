class Api::V2::TeamsController < Api::V2::ApiController

  def me
    @teams = api_user.teams
  end

end