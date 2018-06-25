# frozen_string_literal: true

class TeamMemberController < ApplicationController
  def index
    @members = current_team.team_members
  end
end
