# frozen_string_literal: true

class TeamSelectorController < ApplicationController

  def index
    # If user has only one team, redirect to that team's dashboard
    if current_user.teams.one?  && current_user.team_invites.empty?
      redirect_to dashboard_path(team: current_user.teams.first.slug)
    end
    @teams = current_user.teams
    @invites = current_user.team_invites.where(accepted_at: nil).where(declined_at: nil)
  end

end
