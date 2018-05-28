# frozen_string_literal: true

class TeamSelectorController < ApplicationController

  def index
    # If user has only one team, redirect to that team's dashboard
    if current_user.teams.one?
      redirect_to dashboard_path(tenant: current_user.teams.first.slug)
    end
    @teams = current_user.teams
  end

end
