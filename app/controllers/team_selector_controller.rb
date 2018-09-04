# frozen_string_literal: true

class TeamSelectorController < ApplicationController

  def index
    # If user has only one team, and no invites, go to the page of that team
    if current_user.teams.one? && current_user.open_invites.empty?
      redirect_to dashboard_path(team: current_user.teams.first.slug)
    end
    @teams = current_user.teams
    @invites = current_user.open_invites
  end

end
