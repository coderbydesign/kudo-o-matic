# frozen_string_literal: true

class TeamMemberController < ApplicationController
  def index
    @members = current_team.manageable_members(current_user)
  end

  def delete
    @member = TeamMember.find(params[:id])
    @member.destroy

    redirect_to manage_team_members_path(current_team.slug)
  end
end
